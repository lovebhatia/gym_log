import '../../animations/transitions.dart';
import '../../component/icon_content.dart';
import '../../component/reusable_card.dart';
import '../../component/round_icon_button.dart';
import '../../constants/constants.dart';
import '../../resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/bmi/calculator_brain.dart';
import 'results_page.dart';

enum Gender {
  male,
  female,
}

class BMIScreen extends StatefulWidget {
  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  late Gender selectedGender = Gender.male;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.BLACK,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.BLACK,
          body: ListView(
            children: <Widget>[
              // Add SizedBox to create space above BMI header
              SizedBox(height: 20.h),

              Padding(
                padding: EdgeInsets.only(top: 5.h, left: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BMI',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'CALCULATOR',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xfff953c6),
                          letterSpacing: 3),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        updateGender(Gender.male);
                      },
                      child: ReusableCard(
                        onPress: () {},
                        gradient: selectedGender == Gender.male
                            ? kActiveCardColour
                            : kInactiveCardColour,
                        cardChild: IconContent(
                          icon: FontAwesomeIcons.mars,
                          iconSize: 60.0,
                          label: 'MALE',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        updateGender(Gender.female);
                      },
                      child: ReusableCard(
                        onPress: () {},
                        gradient: selectedGender == Gender.female
                            ? kActiveCardColour
                            : kInactiveCardColour,
                        cardChild: IconContent(
                          icon: FontAwesomeIcons.venus,
                          label: 'FEMALE',
                          iconSize: 60.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ReusableCard(
                gradient: kActiveCardColour,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'HEIGHT',
                      style: kLabelTextStyle.copyWith(
                        fontSize: 14.sp, // Smaller font size
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ), // Reduced space between label and value
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          height.toString(),
                          style: kNumberTextStyle.copyWith(
                            fontSize: 28.sp, // Smaller font size
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        ), // Reduced space between value and unit
                        Text(
                          'cm',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 14.sp, // Smaller font size
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ), // Space between value and slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        inactiveTrackColor: const Color(0xFF8D8E98),
                        activeTrackColor: Colors.white,
                        thumbColor: Colors.white,
                        overlayColor: const Color(0x29EB1555),
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10.0), // Smaller thumb radius
                        overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 20.0), // Smaller overlay radius
                      ),
                      child: Slider(
                        value: height.toDouble(),
                        min: 120.0,
                        max: 220.0,
                        onChanged: (double newValue) {
                          updateHeight(newValue);
                        },
                      ),
                    ),
                  ],
                ),
                onPress: () {},
              ),
              // Reduced space between weight and age cards
              SizedBox(height: 5.h),
              Row(
                children: <Widget>[
                  // Increased width of weight card
                  Container(
                    width: 170.w, // Set width for weight card
                    child: ReusableCard(
                      gradient: kActiveCardColour,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'WEIGHT',
                            style: kLabelTextStyle,
                          ),
                          Text(
                            weight.toString(),
                            style: kNumberTextStyle,
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              inactiveTrackColor: const Color(0xFF8D8E98),
                              activeTrackColor: Colors.white,
                              thumbColor: Colors.white,
                              overlayColor: const Color(0x29EB1555),
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius:
                                      10.0), // Smaller thumb radius
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius:
                                      20.0), // Smaller overlay radius
                            ),
                            child: Slider(
                              value: weight.toDouble(),
                              min: 30.0,
                              max: 200.0,
                              onChanged: (double newValue) {
                                updateWeight(newValue);
                              },
                            ),
                          ),
                        ],
                      ),
                      onPress: () {},
                    ),
                  ),
                  // Increased width of age card
                  SizedBox(width: 10.w), // Reduced space between cards
                  Container(
                    width: 170.w, // Set width for age card
                    child: ReusableCard(
                      gradient: kActiveCardColour,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'AGE',
                            style: kLabelTextStyle,
                          ),
                          Text(
                            age.toString(),
                            style: kNumberTextStyle,
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              inactiveTrackColor: const Color(0xFF8D8E98),
                              activeTrackColor: Colors.white,
                              thumbColor: Colors.white,
                              overlayColor: const Color(0x29EB1555),
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius:
                                      10.0), // Smaller thumb radius
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius:
                                      20.0), // Smaller overlay radius
                            ),
                            child: Slider(
                              value: age.toDouble(),
                              min: 1.0,
                              max: 120.0,
                              onChanged: (double newValue) {
                                updateAge(newValue);
                              },
                            ),
                          ),
                        ],
                      ),
                      onPress: () {},
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.h, left: 105.w, right: 105.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 15,
                    backgroundColor: Colors.transparent,
                    shadowColor: AppColors.LIGHT_BLACK,
                    padding: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    CalculatorBrain calc =
                        CalculatorBrain(height: height, weight: weight);

                    Navigator.push(
                      context,
                      SlideLeftTransition(
                        ResultsPage(
                          bmiResult: calc.calculateBMI(),
                          resultText: calc.getResult(),
                          interpretation: calc.getInterpretation(),
                        ),
                      ),
                    );
                  },
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
                      constraints:
                          BoxConstraints(minWidth: 108.w, minHeight: 36.0.h),
                      padding: EdgeInsets.all(12.h),
                      alignment: Alignment.center,
                      child: Text(
                        'CALCULATE',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 18.sp, // Adjusted font size
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.white, // Ensure contrast with background
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}
