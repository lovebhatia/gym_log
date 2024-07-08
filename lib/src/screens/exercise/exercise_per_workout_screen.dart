import 'package:gym_log_exercise/src/model/exercise/exercise_per_workout_model.dart';
import 'package:gym_log_exercise/src/service/exercise_per_workout_service.dart';
import '../../animations/transitions.dart';
import '../../resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExercisePerWorkoutScreen extends StatefulWidget {
  final String selectedDay;
  final String id;

  const ExercisePerWorkoutScreen({
    super.key,
    required this.selectedDay,
    required this.id,
  });

  @override
  _DayWorkoutScreenState createState() => _DayWorkoutScreenState();
}

class _DayWorkoutScreenState extends State<ExercisePerWorkoutScreen> {
  late List<ExercisesPerWorkoutModel> displayedExercises = [];
  late List<ExercisesPerWorkoutModel> workoutExercises = [];

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
        displayedExercises = fetchedExercisePerDay;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    workoutExercises = List.from(displayedExercises);

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
              SizedBox(
                height: 25.h,
              ),
              /*
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return ExcerciseTile(
                      gif: displayedExercises[index].gifName,
                      nameOfExcercise: displayedExercises[index].exerciseName,
                      //restTime: displayedExcercises[index].,
                      sets: displayedExercises[index].setRange,
                      //time: displayedExcercises[index].,
                      description:
                          displayedExercises[index].exerciseDescription,
                    );
                    // return Text(displayedExcercises[index].nameOfExcercise,style: TextStyle(color: Colors.white,fontSize: 25),);
                  },
                  itemCount: displayedExercises.length,
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
