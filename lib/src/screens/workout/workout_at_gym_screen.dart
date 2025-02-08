import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_log_exercise/src/model/workout/workout_program_model.dart';
import 'package:gym_log_exercise/src/service/workout_program_service.dart';
import 'package:gym_log_exercise/src/widgets/workout/workout_card_widget.dart';
import 'package:gym_log_exercise/src/widgets/workout/workout_grid_widget.dart';
import '../../animations/transitions.dart';
import '../../constants/app_colors.dart';

class WorkoutAtGymScreen extends StatefulWidget {
  const WorkoutAtGymScreen({super.key});

  @override
  _WorkoutAtGymScreenState createState() => _WorkoutAtGymScreenState();
}

class _WorkoutAtGymScreenState extends State<WorkoutAtGymScreen> {
  late List<WorkoutProgramModel> displayedWorkoutProgram = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchWorkoutProgram();
  }

  // Define a mapping of workout program names to corresponding methods or routes

  Future<void> _fetchWorkoutProgram() async {
    try {
      final fetchedWorkoutProgram =
          await WorkoutProgramService().fetchWorkoutProgram();
      setState(() {
        displayedWorkoutProgram = fetchedWorkoutProgram;
      });
    } catch (error) {}
  }

  final Map<String, IconData> backendIconMapping = {
    'Push/Pull/Legs': Icons.fitness_center,
    'Full Body': Icons.accessibility,
    'Upper/Lower Split': Icons.swap_vert,
    'Body Part Split': Icons.filter_frames,
    'Cardiovascular': Icons.directions_run,
    'Flexibility and Mobility': Icons.self_improvement,
    'HIIT': Icons.timer,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BLACK,
      appBar: AppBar(
        backgroundColor: AppColors.BLACK,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
          color: AppColors.BLACK,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WorkoutGridWidget(), // Normal workouts and exercises
              SizedBox(height: 20.h),

              // Creating a List where each item is a Row containing a horizontal scroll of 3 items
              ListView.builder(
                shrinkWrap: true, // Important to fit inside Column
                physics:
                    const NeverScrollableScrollPhysics(), // Prevents vertical scrolling inside this ListView
                itemCount: (displayedWorkoutProgram.length / 4)
                    .ceil(), // Number of rows
                itemBuilder: (context, rowIndex) {
                  int startIndex = rowIndex * 4;
                  int endIndex = startIndex + 4;
                  if (endIndex > displayedWorkoutProgram.length) {
                    endIndex = displayedWorkoutProgram.length;
                  }

                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: 15.h), // Space between rows
                    child: SizedBox(
                      height: 70.h, // Adjust height for cards
                      child: ListView.builder(
                        scrollDirection:
                            Axis.horizontal, // Enables horizontal scrolling
                        itemCount:
                            endIndex - startIndex, // Only valid items in row
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                right: 15.w), // Space between cards
                            child: WorkoutCard(
                              workoutProgram:
                                  displayedWorkoutProgram[startIndex + index],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
