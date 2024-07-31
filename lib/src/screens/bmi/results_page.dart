import '../../component/reusable_card.dart';
import '../../constants/constants.dart';
import '../../resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultsPage extends StatelessWidget {
  ResultsPage(
      {required this.interpretation,
      required this.bmiResult,
      required this.resultText});

  final String bmiResult;
  final String resultText;
  final String interpretation;

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
            title: Text(
              'BMI CALCULATOR',
              style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // SizedBox(height: 15.h,),
              Container(
                padding: EdgeInsets.all(15.0.h),
                child: Center(
                  child: Text(
                    'Your Result',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 35.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10.h,),
              ReusableCard(
                gradient: const LinearGradient(
                    colors: [AppColors.LIGHT_BLACK, AppColors.LIGHT_BLACK]),
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 40.h,
                    ),
                    Text(
                      resultText.toUpperCase(),
                      style: kResultTextStyle,
                    ),
                    Text(
                      bmiResult,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 100,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 18.0.h, left: 28.w, right: 28.w),
                      child: Text(
                        interpretation,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
                onPress: () {},
              ),
              // SizedBox(height: 40.h,),
              Padding(
                padding: EdgeInsets.only(top: 15.h, left: 105.w, right: 105.w),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                        colors: [
                          Color(0xffaa076b),
                          Color(0xff61045f),
                        ],
                      ),
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                          minWidth: 300.0.w,
                          minHeight: 50.0.h), // Increased width
                      padding: EdgeInsets.all(12.h),
                      alignment: Alignment.center,
                      child: Text(
                        'RE - CALCULATE',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 15.sp, // Adjusted font size
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.white, // Ensure contrast with background
                          ),
                        ),
                        maxLines: 1, // Ensure the text stays on a single line
                        overflow:
                            TextOverflow.ellipsis, // Handle overflow gracefully
                      ),
                    ),
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
