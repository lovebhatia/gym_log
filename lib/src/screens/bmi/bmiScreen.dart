import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../animations/transitions.dart';
import '../../constants/app_colors.dart';
import '../../widgets/bmi/calculator_brain.dart';
import 'results_page.dart';

enum Gender { male, female }

class BMIScreen extends StatefulWidget {
  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  Gender selectedGender = Gender.male;
  int height = 180;
  int weight = 60;
  int age = 20;

  void updateGender(Gender gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void updateHeight(double newHeight) {
    setState(() {
      height = newHeight.round();
    });
  }

  void updateWeight(double newWeight) {
    setState(() {
      weight = newWeight.round();
    });
  }

  void updateAge(double newAge) {
    setState(() {
      age = newAge.round();
    });
  }

  String getHeightInFeetInches(int cm) {
    int feet = (cm ~/ 30.48).toInt();
    int inches = ((cm % 30.48) / 2.54).round();
    return "$feet' $inches\" ft in";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 72, 77, 97), Color(0xff0F2027)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 10.h), // Added gap above the title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BMI',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'CALCULATOR',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(237, 140, 225, 75),
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h), // Added gap below the title
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            updateGender(Gender.male);
                          },
                          child: Card(
                            elevation: 6,
                            color: selectedGender == Gender.male
                                ? const Color.fromARGB(255, 157, 220, 155) 
                                : const Color.fromARGB(255, 234, 236, 234),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.mars,
                                    size: 29.sp,
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'MALE',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w800,
                                      color: const Color.fromARGB(255, 6, 5, 5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            updateGender(Gender.female);
                          },
                          child: Card(
                            elevation: 6,
                            color: selectedGender == Gender.female
                                 ? const Color.fromARGB(255, 157, 220, 155)
                                : const Color.fromARGB(255, 234, 236, 234),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.venus,
                                    size: 29.sp,
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'FEMALE',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Card(
                    elevation: 6,
                    color: const Color(0xff111111),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'HEIGHT',
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                height.toString(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'cm',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            getHeightInFeetInches(height),
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                          ),
                          Slider(
                            value: height.toDouble(),
                            min: 120.0,
                            max: 220.0,
                            onChanged: updateHeight,
                            activeColor: const Color.fromARGB(255, 157, 220, 155),
                            inactiveColor: Colors.white30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Card(
                    elevation: 6,
                    color: const Color(0xff111111),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'WEIGHT',
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                weight.toString(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'kg',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: weight.toDouble(),
                            min: 30.0,
                            max: 200.0,
                            onChanged: updateWeight,
                            activeColor: const Color.fromARGB(255, 157, 220, 155),
                            inactiveColor: Colors.white30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Card(
                    elevation: 6,
                    color: const Color(0xff111111),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'AGE',
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                age.toString(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'years',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: age.toDouble(),
                            min: 15.0,
                            max: 80.0,
                            onChanged: updateAge,
                            activeColor: const Color.fromARGB(255, 157, 220, 155),
                            inactiveColor: Colors.white30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    width: 160.w, // Adjusted width to make the button smaller
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color.fromARGB(235, 118, 161, 85) ,Color.fromARGB(185, 70, 154, 76)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                      CalculatorBrain calc = CalculatorBrain();
                      String _bmiResult = calc.calculateBMI(height, weight);
                      Navigator.push(
                        context,
                        SlideLeftTransition(
                          ResultsPage(
                            bmiResult: calc.calculateBMI(height, weight),
                            resultText: calc.getResult(_bmiResult),
                            interpretation: calc.getInterpretation(_bmiResult),
                          ),
                        ),
                      );
                    },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h), // Adjusted padding to reduce height
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                      ),
                      child: Text(
                        'CALCULATE',
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp, // Slightly reduced font size
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  //SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
