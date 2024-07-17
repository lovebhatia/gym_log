import 'package:flutter/material.dart';
import 'package:gym_log_exercise/src/model/exercise/rep_record_per_user_model.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/exercise/exercise_per_user_model.dart';

class ExerciseHistoryPage extends StatefulWidget {
  @override
  _ExerciseHistoryPageState createState() => _ExerciseHistoryPageState();
}

class _ExerciseHistoryPageState extends State<ExerciseHistoryPage> {
  String selectedDayFilter = 'All';
  String selectedExerciseFilter = 'All';
  DateTime selectedDateFilter = DateTime.now();
  List<ExercisePerUserModel> exerciseHistory = []; // Populate with API data

  @override
  void initState() {
    super.initState();
    _fetchExerciseHistory();
  }

  Future<void> _fetchExerciseHistory() async {
    // Fetch exercise history data from API
    // For now, use dummy data
    setState(() {
      exerciseHistory = [
        // Populate with real data
      ];
    });
  }

  void _applyFilters() {
    setState(() {
      // Apply the selected filters to the exercise history
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercise History',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Day Filter
                DropdownButton<String>(
                  value: selectedDayFilter,
                  items: ['All', 'Yesterday', 'Day Before Yesterday']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedDayFilter = newValue!;
                      _applyFilters();
                    });
                  },
                ),
                // Date Filter
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDateFilter,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null &&
                        pickedDate != selectedDateFilter) {
                      setState(() {
                        selectedDateFilter = pickedDate;
                        _applyFilters();
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        DateFormat('yyyy-MM-dd').format(selectedDateFilter),
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Exercise Filter
                DropdownButton<String>(
                  value: selectedExerciseFilter,
                  items: ['All', 'Bench Press', 'Squats', 'Deadlift']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedExerciseFilter = newValue!;
                      _applyFilters();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Exercise History List
            Expanded(
              child: ListView.builder(
                itemCount: exerciseHistory.length,
                itemBuilder: (context, index) {
                  return _buildAccordion(exerciseHistory[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion(ExercisePerUserModel exerciseSet) {
    String formattedDate = DateFormat('EEEE, yyyy-MM-dd')
        .format(exerciseSet.createdAt); // Added day of the week
    return ExpansionTile(
      backgroundColor: Colors.blueGrey[900],
      collapsedBackgroundColor: Colors.blueGrey[800],
      tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      title: Text(
        formattedDate,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: exerciseSet.exerciseSetRecords.map((record) {
            return _buildExerciseRecord(record);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExerciseRecord(RepsRecordPerUserModel record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${record.set != 0 ? record.set : 3} - ${record.weight}kg - ${record.reps} reps',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
