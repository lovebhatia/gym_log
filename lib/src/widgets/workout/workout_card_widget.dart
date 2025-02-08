import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/workout/workout_program_model.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutProgramModel workoutProgram;

  const WorkoutCard({required this.workoutProgram, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 70.h, // Ensure height is respected
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          // Force height constraint
          height: 70.h,
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  'https://gymfitbucket.s3.eu-north-1.amazonaws.com/asset/images/abs/abs_home.jpg',
                  fit: BoxFit
                      .cover, // Ensures it does not expand beyond container
                ),
              ),

              // Dark Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.8)
                      ],
                    ),
                  ),
                ),
              ),

              // Title
              Positioned(
                top: 8.h,
                left: 10.w,
                right: 10.w,
                child: Center(
                  child: Text(
                    workoutProgram.workoutProgramName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Category Label
              Positioned(
                top: 30.h,
                left: 20.w,
                right: 20.w,
                child: Center(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      workoutProgram.mainGoal,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),

              // Rating & Followers
              Positioned(
                bottom: 5.h,
                left: 8.w,
                right: 8.w,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 10.sp),
                      SizedBox(width: 3.w),
                      Text(
                        '${workoutProgram.rating}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
