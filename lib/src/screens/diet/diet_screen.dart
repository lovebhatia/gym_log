import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_log_exercise/src/constants/app_colors.dart';
import 'package:gym_log_exercise/src/screens/diet/daydietplan/gymdiet_screen.dart';

import '../../animations/transitions.dart';
import 'intermittent_fasting/intermittent_fasting_screen.dart';
import 'keto/ketodiet_screen.dart';

class DietScreen extends StatefulWidget {
  // const DietScreen({Key? key}) : super(key: key);

  @override
  _DietScreenState createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.BLACK,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.BLACK,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 25.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Diet',
                        style: GoogleFonts.bebasNeue(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 3),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'Plan',
                        style: GoogleFonts.bebasNeue(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xfff5af19),
                            letterSpacing: 3),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35.h,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 30.w,
                  ),
                  child: Text(
                    'Choose from our Top Picks,',
                    style: GoogleFonts.lato(
                      fontSize: 22.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.w),
                  child: Text(
                    'Powerful weight loss diets.',
                    style: GoogleFonts.lato(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideLeftTransition(KetoDietScreen()),
                      );
                    },
                    child: Container(
                      height: 100.h,
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xfff12711),
                            Color(0xfff5af19),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KETO DIET',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 22.sp,
                              ),
                            ),
                          ),
                          Text(
                            'Upto 12 kgs in 30 Days',
                            style: GoogleFonts.teko(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 25.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideLeftTransition(IntermittentScreen()),
                      );
                    },
                    child: Container(
                      height: 100.h,
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            //orange.........
                            Color(0xfff12711),
                            Color(0xfff5af19),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INTERMITTENT FASTING',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 22.sp,
                              ),
                            ),
                          ),
                          Text(
                            'Upto 8 kgs in 30 Days',
                            style: GoogleFonts.teko(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 25.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideLeftTransition(const GymDietScreen()),
                      );
                    },
                    child: Container(
                      height: 100.h,
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            //orange.........
                            Color(0xfff12711),
                            Color(0xfff5af19),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GYM DIET',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 22.sp,
                              ),
                            ),
                          ),
                          Text(
                            'Upto 15 pounds in 7 Days',
                            style: GoogleFonts.teko(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 25.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
