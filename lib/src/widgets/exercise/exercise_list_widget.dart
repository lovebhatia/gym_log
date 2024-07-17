import 'package:flutter/material.dart';
import 'package:gym_log_exercise/src/model/exercise/exercise_per_workout_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_log_exercise/src/widgets/exercise/exercise_tile_widget.dart';
import '../../resources/app_colors.dart';

class ExerciseListWidget extends StatelessWidget {
  final List<ExercisesPerWorkoutModel> exercises;
  final String selectedWorkout;
  const ExerciseListWidget(
      {super.key, required this.exercises, required this.selectedWorkout});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (ctx, index) {
          return ExerciseTileWidget(
            gif: exercises[index].gifName,
            exerciseName: exercises[index].exerciseName,
            sets: exercises[index].setRange,
            description: exercises[index].exerciseDescription,
          );
        },
        itemCount: exercises.length,
      ),
    );
  }
}
