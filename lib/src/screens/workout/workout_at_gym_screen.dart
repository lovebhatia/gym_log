import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_log_exercise/src/model/workout/workout_program_model.dart';
import 'package:gym_log_exercise/src/service/workout_program_service.dart';
import 'package:gym_log_exercise/src/widgets/workout/workout_grid_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BLACK,
      appBar: AppBar(
        /*
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        */
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
              const WorkoutGridWidget(), //showing normal  workout and exercise
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
