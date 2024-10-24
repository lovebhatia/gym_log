import 'package:flutter/material.dart';
import 'package:gym_log_exercise/src/screens/exercise/exercise_details_screen.dart';
import 'package:gym_log_exercise/src/widgets/workout/start_screen_widget.dart';
import '../../animations/transitions.dart';
import '../../constants/app_colors.dart';
import '../../model/exercise/exercise_per_workout_model.dart';
import '../../service/exercise_per_workout_service.dart';
import '../../widgets/exercise/exercise_header_details_widget.dart';
import '../../widgets/exercise/exercise_list_widget.dart';
import '../workout/start_workout_screen.dart';

class ExercisePerWorkoutScreen extends StatefulWidget {
  final String selectedWorkout;
  final String id;

  const ExercisePerWorkoutScreen({
    super.key,
    required this.selectedWorkout,
    required this.id,
  });

  @override
  _ExercisePerWorkoutScreenState createState() =>
      _ExercisePerWorkoutScreenState();
}

class _ExercisePerWorkoutScreenState extends State<ExercisePerWorkoutScreen> {
  late List<ExercisesPerWorkoutModel> exercisePerWorkoutList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchExercisePerDay();
  }

  Future<void> _fetchExercisePerDay() async {
    try {
      final fetchedExercisePerDay =
          await ExercisePerWorkoutService().fetchExercisesPerWorkout(widget.id);
      setState(() {
        exercisePerWorkoutList = fetchedExercisePerDay;
      });
    } catch (error) {
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.BLACK,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.BLACK,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: AppColors.BLACK,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ExerciseHeaderDetailsWidget(
                selectedDay: widget.selectedWorkout,
                totalExercises: exercisePerWorkoutList.length,
                onStartWorkout: () {
                  Navigator.push(
                    context,
                    UpTransition1(
                      BegWorkoutWidget(
                          workoutExercises: exercisePerWorkoutList,
                          selectedWorkout: widget.selectedWorkout
                          ),
                    ),
                  );
                },
              ),
              ExerciseListWidget(
                  exercises: exercisePerWorkoutList,
                  selectedWorkout: widget.selectedWorkout),
            ],
          ),
        ),
      ),
    );
  }
}
