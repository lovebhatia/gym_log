import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gym_log_exercise/src/model/workout/workout_model.dart';
import 'package:gym_log_exercise/src/model/workout/workout_program_model.dart';
import 'package:gym_log_exercise/src/screens/exercise/exercise_per_workout_screen.dart';
import 'package:gym_log_exercise/src/service/workout_program_service.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constant.dart';

class WorkoutGridWidget extends StatefulWidget {
  const WorkoutGridWidget({super.key});

  @override
  _WorkoutGridState createState() => _WorkoutGridState();
}

class _WorkoutGridState extends State<WorkoutGridWidget> {
  late List<WorkoutModel> workoutList = [];
  late List<WorkoutProgramModel> displayedWorkoutProgram = [];

  Future<void> _fetchWorkoutProgram() async {
    try {
      final fetchedWorkoutProgram =
          await WorkoutProgramService().fetchWorkoutProgram();
      setState(() {
        displayedWorkoutProgram = fetchedWorkoutProgram;
      });
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
    _fetchExerciseDays();
    _fetchWorkoutProgram();
  }

  Future<void> _fetchExerciseDays() async {
    try {
      final fetchedExerciseDayList =
          await WorkoutProgramService().fetchWorkout();
      setState(() {
        workoutList = fetchedExerciseDayList;
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'Exercise Library',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workoutList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Display 3 items in each row
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 0.9, // Adjust the aspect ratio as needed
          ),
          itemBuilder: (context, index) {
            final exercise = workoutList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExercisePerWorkoutScreen(
                      selectedWorkout : exercise.workout,
                      id: exercise.id.toString(),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: AppColors
                            .LIGHT_BLACK, // Background color for the rounded container
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          '${AppConst.imageBaseUrl}${exercise.workout.toLowerCase().trim().replaceAll(' ', '')}/${exercise.imageName}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    exercise.workout,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
