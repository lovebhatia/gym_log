import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_log_exercise/src/model/workout/workout_program_model.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutProgramModel workoutProgram;

  const WorkoutCard({required this.workoutProgram, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workoutProgram.workoutProgramName,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Rating: ${workoutProgram.rating}',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 5.h),
            Text(
              'Main Goal: ${workoutProgram.mainGoal}',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 5.h),
            Text(
              'Duration: ${workoutProgram.durationRange}',
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 5.h),
            Text(
              'Days per Week: ${workoutProgram.daysPerWeek}',
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
