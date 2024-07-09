import 'package:gym_log_exercise/src/model/exercise/exercise_per_workout_model.dart';

import '../../resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/app_constant.dart';

class ExerciseDetailsWidget extends StatefulWidget {
  final List<ExercisesPerWorkoutModel> exercisePerWorkoutList;

  const ExerciseDetailsWidget({
    super.key,
    required this.exercisePerWorkoutList,
  });

  @override
  _BegWorkoutWidgetState createState() => _BegWorkoutWidgetState();
}

class _BegWorkoutWidgetState extends State<ExerciseDetailsWidget> {
  bool isCircle = false;

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      itemCount: widget.exercisePerWorkoutList.length,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          child: Container(
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
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(17.h),
                  height: 250.h,
                  width: double.infinity,
                  child: Card(
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      /* 
                  child: Image(
                    image: AssetImage(widget.workoutExcercises[index].gif),
                  ), //...........................
                  */

                      child: Image(
                        image: NetworkImage('${AppConst.ChestGifBaseUrl}'
                            '${widget.exercisePerWorkoutList[index].gifName}'),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 30.w),
                    Text(
                      widget.exercisePerWorkoutList[index].exerciseName,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.0.h, left: 27.w, right: 22.w),
                  /*
                  child: RepsRecordScreen(
                      nameOfExcercise:
                          widget.workoutExcercises[index].exerciseName),
                          */
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Align buttons at the ends
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.previousPage(
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.linearToEaseOut);
                      },
                      child: Text(
                        'Back',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    index == widget.exercisePerWorkoutList.length - 1
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.of(context).pop();
                              isCircle = true;
                              show(context);
                            },
                            child: Text(
                              'Exit',
                              style: GoogleFonts.blinker(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              controller.nextPage(
                                  duration: Duration(milliseconds: 1000),
                                  curve: Curves.linearToEaseOut);
                            },
                            child: Text(
                              'Replace Exercise',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    TextButton(
                      onPressed: () {
                        controller.nextPage(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.linearToEaseOut);
                      },
                      child: Text(
                        'Next',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void show(BuildContext context) {
    AchievementView(
      alignment: Alignment.topCenter,
      color: AppColors.LIGHT_BLACK,
      // textStyleTitle: TextStyle(fontWeight: FontWeight.bold),
      elevation: 50,
      // icon: Icon(Icons.done_all),
      duration: const Duration(milliseconds: 3000),
      title: "Yeaaah!",
      subTitle: "Training completed  ",
      textStyleSubTitle: TextStyle(
        fontSize: 12.0.sp,
        // fontWeight: FontWeight.w600,
      ),
      isCircle: isCircle,
    ).show(context);
  }
}
