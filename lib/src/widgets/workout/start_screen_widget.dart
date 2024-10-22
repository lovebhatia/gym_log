import 'package:flutter/material.dart';
import 'package:gym_log_exercise/src/model/exercise/exercise_per_workout_model.dart';
import 'package:intl/intl.dart';
import 'package:gym_log_exercise/src/widgets/exercise/exercise_list_widget.dart';

import '../../constants/app_colors.dart';

class BegWorkoutWidget extends StatefulWidget {
  final List<ExercisesPerWorkoutModel> workoutExercises;
  final String selectedWorkout;

  BegWorkoutWidget({
    required this.workoutExercises,
    required this.selectedWorkout,
  });

  @override
  _BegWorkoutWidgetState createState() => _BegWorkoutWidgetState();
}

class _BegWorkoutWidgetState extends State<BegWorkoutWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  // Track the currently selected index
  int _selectedIndex = 15; // Set to 15 (today) by default

  @override
  void initState() {
    super.initState();

    // Initialize TabController and ScrollController
    _tabController = TabController(length: 31, vsync: this, initialIndex: _selectedIndex); // 15th index is today
    _scrollController = ScrollController();

    // Automatically scroll to today's date after the frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Function to scroll to the current date (15th index)
  void _scrollToCurrentDate() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _selectedIndex * 80.0, // Each item has a width of 80 pixels
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    // Generate a list of 31 dates: 15 days before and 15 days after today
    List<DateTime> dateRange = List.generate(31, (index) => today.subtract(Duration(days: 15 - index)));

    return Scaffold(
      backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: AppColors.BLACK,
            elevation: 0,
          ),
      
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: SizedBox(
              height: 80,  // Height for the date cards
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: dateRange.length,
                itemBuilder: (context, index) {
                  DateTime date = dateRange[index];
                  bool isToday = index == 15;
                  bool isSelected = index == _selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                        _tabController.index = index; // Update the tab to the selected date
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isToday
                            ? const Color(0xfff5af19)  // Highlight today's date
                            : isSelected
                                ? Colors.blueAccent  // Highlight selected date
                                : Colors.grey[850],  // Default color for other dates
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: (isToday || isSelected)
                            ? [
                                BoxShadow(
                                  color: (isToday ? Colors.orange : Colors.blueAccent).withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd MMM').format(date),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isToday || isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              fontSize: 14,
                              color: isToday || isSelected ? Colors.black : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: dateRange.map((date) {
                // Filter exercises for the specific date
                List<ExercisesPerWorkoutModel> filteredExercises = widget.workoutExercises
                    .where((exercise) => _isExerciseForDate(exercise, date))
                    .toList();

                return ExerciseListWidget(
                  exercises: filteredExercises,
                  selectedWorkout: widget.selectedWorkout,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Function to determine if an exercise is for a specific date
  bool _isExerciseForDate(ExercisesPerWorkoutModel exercise, DateTime date) {
    // You need to implement this logic based on your exercise model and requirements.
    // This example assumes that exercises have a date range or specific date logic.
    return true; // Placeholder: Adjust according to your actual logic
  }
}
