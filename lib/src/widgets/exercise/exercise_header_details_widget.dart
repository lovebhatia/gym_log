import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_colors.dart';

class ExerciseHeaderDetailsWidget extends StatelessWidget {
  final String selectedDay;
  final VoidCallback onStartWorkout;

  const ExerciseHeaderDetailsWidget({
    super.key,
    required this.selectedDay,
    required this.onStartWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h),
      child: Center(
        child: Container(
          height: 100.h,
          width: 350.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff8E2DE2), Color(0xff4A00E0)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30.0.h, left: 58.w, right: 58.w),
                child: Text(
                  selectedDay,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.only(left: 12.w, right: 12.w),
                child: const IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              /*
              ElevatedButton(
                onPressed: onStartWorkout,
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  backgroundColor: Colors.transparent,
                  shadowColor: AppColors.LIGHT_BLACK,
                  padding: const EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff434343), Color(0xff000000)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Container(
                    constraints:
                        BoxConstraints(minWidth: 108.w, minHeight: 36.0.h),
                    padding: EdgeInsets.all(12.h),
                    child: Text(
                      'START WORKOUT',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
