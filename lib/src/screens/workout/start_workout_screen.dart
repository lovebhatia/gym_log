import 'package:flutter/material.dart';
import 'package:gym_log_exercise/src/model/exercise/exercise_per_workout_model.dart';

import '../../constants/app_colors.dart';
import '../../widgets/workout/start_screen_widget.dart';

class BeginnerStartWorkoutScreen extends StatelessWidget {
  final List<ExercisesPerWorkoutModel> exercisePerWorkoutList;
  final String selectedWorkout;

  BeginnerStartWorkoutScreen({
    required this.exercisePerWorkoutList,
    required this.selectedWorkout
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.DARK_PURPLE,
            AppColors.BRIGHT_PURPLE,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: BegWorkoutWidget(
            workoutExercises: exercisePerWorkoutList,
            selectedWorkout: selectedWorkout
          ),
        ),
      ),
    );
  }
}
