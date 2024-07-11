import '../../resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/app_constant.dart';
import '../../screens/reps/reps_record_screen.dart';

class ExerciseDetailsWidget extends StatelessWidget {
  final String gif;
  final String exerciseName;
  final String sets;
  final String description;

  const ExerciseDetailsWidget({
    super.key,
    required this.gif,
    required this.exerciseName,
    required this.sets,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: [
          Container(
            height: 500.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.BLACK,
                  AppColors.LIGHT_BLACK,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.0.w, right: 25.w),
                  child: Container(
                    padding: const EdgeInsets.only(top: 32),
                    height: 200.h,
                    width: 350.w,
                    child: Image(
                      image: NetworkImage('${AppConst.ChestGifBaseUrl}$gif'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      exerciseName, //........................................
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.0.h, left: 27.w, right: 22.w),
                  child: RepsRecordScreen(
                    exerciseName: exerciseName,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
