import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/exercise/exercise_per_user_model.dart';
import '../../model/exercise/rep_record_per_user_model.dart';
import '../../service/reps_service.dart';
import '../../widgets/reps/reps_record_widget.dart';
import '../../widgets/reps/reps_history_widget.dart';

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
  List<ExercisePerUserModel> exerciseSetsHistory = [];

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
    _fetchHistory();
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
    bool success = await repsService.createExerciseSet(dataToSend);

    if (success) {
      _showToast('Data Saved Successfully');
    } else {
      _showToast('Failed to save data. Please try again.');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);
    var userId = extractedUserData['userId'];
    final exerciseService = RepsService();
    try {
      List<ExercisePerUserModel> fetchedData =
          await exerciseService.fetchExerciseSets(widget.exerciseName, userId);
      print('Fetched data: $fetchedData'); // Debug print
      setState(() {
        exerciseSets = fetchedData;
        rows = [];
        weightControllers.clear();
        repsControllers.clear();
        rowData.clear();
        bool hasValidData = false;
        for (var exerciseSet in exerciseSets) {
          for (var record in exerciseSet.exerciseSetRecords) {
            _addExistingRow(record);
            if (record.reps != null || record.weight != null) {
              hasValidData = true;
            }
          }
        }
        if (!hasValidData) {
          for (int i = 0; i < 3; i++) {
            _addRow();
          }
        }
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  Future<void> _fetchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);
    var userId = extractedUserData['userId'];
    final exerciseService = RepsService();
    try {
      List<ExercisePerUserModel> fetchedData =
          await exerciseService.fetchRepsHistory(widget.exerciseName, userId);
      setState(() {
        exerciseSetsHistory = fetchedData;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  void _addExistingRow(RepsRecordPerUserModel record) {
    setState(() {
      Map<String, dynamic> newRowData = {
        'weight': record.weight != null && record.weight != 0.0
            ? record.weight.toString()
            : '',
        'reps': record.reps != null && record.reps != 0
            ? record.reps.toString()
            : '',
        'set': record.set
      };
      rowData.add(newRowData);

      TextEditingController weightController = TextEditingController(
          text: (record.weight != null && record.weight != 0.0)
              ? record.weight.toString()
              : '');
      TextEditingController repsController = TextEditingController(
          text: (record.reps != null && record.reps != 0)
              ? record.reps.toString()
              : '');

      weightControllers.add(weightController);
      repsControllers.add(repsController);

      rows.add(
        RepsRecordWidget(
          index: record.set,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark background to avoid white space
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Hide the keyboard when tapping outside
          },
          child: SingleChildScrollView(
             reverse: true,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
              children: [
                // Reps Input Section
                Column(
                  children: [
                    ...rows,
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _addRow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                          ),
                          child: const Text('Add More Sets'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _sendDataToApi,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Reps History Section
                RepsHistoryWidget(
                  exerciseSetsHistory: exerciseSetsHistory,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
