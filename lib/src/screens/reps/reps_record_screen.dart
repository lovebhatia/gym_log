import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_log_exercise/src/model/exercise/exercise_per_user_model.dart';
import 'package:gym_log_exercise/src/model/exercise/rep_record_per_user_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/reps_service.dart';
import '../../widgets/reps/reps_record_widget.dart';

class RepsRecordScreen extends StatefulWidget {
  final String exerciseName;
  const RepsRecordScreen({super.key, required this.exerciseName});

  @override
  _RepsRecordScreenState createState() => _RepsRecordScreenState();
}

class _RepsRecordScreenState extends State<RepsRecordScreen> {
  List<Widget> rows = [];
  int rowCount = 3; // Initial number of rows
  List<TextEditingController> weightControllers = [];
  List<TextEditingController> repsControllers = [];
  List<Map<String, dynamic>> rowData = [];
  List<ExercisePerUserModel> exerciseSets = [];

  @override
  void dispose() {
    for (var controller in weightControllers) {
      controller.dispose();
    }
    for (var controller in repsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < rowCount; i++) {
      _addRow();
    }
    _fetchData();
  }

  void _addRow() {
    setState(() {
      int currentIndex = rowData.length + 1;
      Map<String, dynamic> newRowData = {
        'weight': '',
        'reps': '',
        'set': currentIndex
      };
      rowData.add(newRowData);
      TextEditingController weightController = TextEditingController();
      TextEditingController repsController = TextEditingController();
      weightControllers.add(weightController);
      repsControllers.add(repsController);
      rows.add(
        RepsRecordWidget(
          index: currentIndex,
          weightController: weightController,
          repsController: repsController,
          onWeightChanged: (newValue) =>
              _updateRowData(currentIndex - 1, 'weight', newValue),
          onRepsChanged: (newValue) =>
              _updateRowData(currentIndex - 1, 'reps', newValue),
        ),
      );
    });
  }

  void _updateRowData(int index, String field, String value) {
    setState(() {
      rowData[index][field] = value;
    });
  }

  Future<void> _sendDataToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);
    var userId = extractedUserData['userId'];
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    Map<String, dynamic> dataToSend = {
      'exerciseName': widget.exerciseName,
      'userId': userId,
      'records': rowData,
      'date': formattedDate
    };
    final repsService = RepsService();
    await repsService.createExerciseSet(dataToSend);
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);
    var userId = extractedUserData['userId'];
    final exerciseService = RepsService();
    try {
      List<ExercisePerUserModel> fetchedData =
          await exerciseService.fetchExerciseSets(widget.exerciseName, userId);
      setState(() {
        exerciseSets = fetchedData;
        rows = [];
        weightControllers.clear();
        repsControllers.clear();
        rowData.clear();
        for (var exerciseSet in exerciseSets) {
          for (var record in exerciseSet.exerciseSetRecords) {
            _addExistingRow(record);
          }
        }
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  void _addExistingRow(RepsRecordPerUserModel record) {
    setState(() {
      Map<String, dynamic> newRowData = {
        'weight': record.weight.toString(),
        'reps': record.reps.toString(),
        'set': record.set
      };
      rowData.add(newRowData);
      TextEditingController weightController =
          TextEditingController(text: record.weight.toString());
      TextEditingController repsController =
          TextEditingController(text: record.reps.toString());
      weightControllers.add(weightController);
      repsControllers.add(repsController);
      rows.add(
        RepsRecordWidget(
          index: record.set != 0 ? record.set : 3,
          weightController: weightController,
          repsController: repsController,
          onWeightChanged: (newValue) =>
              _updateRowData(record.set - 1, 'weight', newValue),
          onRepsChanged: (newValue) =>
              _updateRowData(record.set - 1, 'reps', newValue),
        ),
      );
    });
  }

  Widget _buildHistory() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                'Set',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Weight (Kg)',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Reps',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      ...exerciseSets.map((exerciseSet) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: exerciseSet.exerciseSetRecords.map((record) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border.all(color: Colors.grey[800]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${record.set != 0 ? record.set : 3}',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${record.weight}',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${record.reps}',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }).toList(),
    ],
  );
}




  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: rows,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addRow,
                  child: const Text('Add More Sets'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendDataToApi,
                  child: const Text('Save'),
                ),
              ],
            ),
             const SizedBox(height: 16),
            _buildHistory(),
          ],
        ),
      ),
    );
  }
}