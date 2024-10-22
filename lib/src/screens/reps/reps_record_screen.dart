import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_log_exercise/src/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/exercise/exercise_per_user_model.dart';
import '../../model/exercise/rep_record_per_user_model.dart';
import '../../service/reps_service.dart';
import '../../widgets/reps/reps_record_widget.dart';
import '../../widgets/reps/reps_history_widget.dart';

class RepsRecordScreen extends StatefulWidget {
  final String exerciseName;
  RepsRecordScreen({super.key, required this.exerciseName});

  @override
  _RepsRecordScreenState createState() => _RepsRecordScreenState();
}

class _RepsRecordScreenState extends State<RepsRecordScreen> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  final GlobalKey _buttonRowKey = GlobalKey();
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToNewRow();
    });
  }

  void _updateRowData(int index, String field, String value) {
    setState(() {
      rowData[index][field] = value;
    });
  }

  Future<void> _sendDataToApi() async {
    setState(() {
      _isLoading = true; // Hide the loading spinner when the API call is done
    });
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
    setState(() {
      _isLoading = false; // Hide the loading spinner when the API call is done
    });
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

  void _scrollToNewRow() {
    final scrollPosition = _scrollController.position;
    final maxScrollExtent = scrollPosition.maxScrollExtent;
    int scrollNumber = 180;
    if (exerciseSetsHistory.length == 0) {
      scrollNumber = 0;
    }

    // Check if the last row is out of view
    if (scrollPosition.pixels != maxScrollExtent) {
      _scrollController.animateTo(
        maxScrollExtent - scrollNumber,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BLACK,
      resizeToAvoidBottomInset: true, // Ensure layout adjusts to keyboard
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Hide keyboard on tap outside
          },
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ...rows,
                  const SizedBox(height: 16),
                  Row(
                    key: _buttonRowKey,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _addRow,
                        child: const Text('Add More Sets'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _sendDataToApi, // Disable button when loading
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          minimumSize: const Size(150,
                              45), // Adjust the size of the button if needed
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  RepsHistoryWidget(
                    exerciseSetsHistory: exerciseSetsHistory,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
