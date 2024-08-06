import '../../animations/transitions.dart';
import '../../common_component/icon_content.dart';
import '../../common_component/reusable_card.dart';
import '../../common_component/round_icon_button.dart';
import '../../constants/constants.dart';
import '../../constants/app_colors.dart';
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

  String getHeightInFeetInches(int cm) {
    int feet = (cm ~/ 30.48).toInt();
    int inches = ((cm % 30.48) / 2.54).round();
    return "$feet' $inches\" ft in";
  }

  @override
  Widget build(BuildContext context) {
    // Ensure age is within the slider range
    if (age < 15) {
      age = 15;
    } else if (age > 60) {
      age = 60;
    }

    return Container(
      color: AppColors.BLACK,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.BLACK,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
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
                      SizedBox(width: 5.w),
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
                  SizedBox(height: 2.h),
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
                              iconSize: 20.0,
                              label: 'MALE',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
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
                              iconSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 0.5.h),
                  ReusableCard(
                    gradient: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'HEIGHT',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              height.toString(),
                              style: kNumberTextStyle.copyWith(
                                fontSize: 15.sp,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'cm',
                              style: kLabelTextStyle.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          getHeightInFeetInches(height),
                          style: kLabelTextStyle.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        //SizedBox(height: 1.h),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: const Color(0xFF8D8E98),
                            activeTrackColor: Colors.white,
                            thumbColor: Colors.white,
                            overlayColor: const Color(0x29EB1555),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10.0),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 20.0),
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
                  //SizedBox(height: 1.h),
                  ReusableCard(
                    gradient: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'WEIGHT',
                          style: kLabelTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              weight.toString(),
                              style: kNumberTextStyle.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'kg',
                              style: kLabelTextStyle.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        //SizedBox(height: 1.h),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: const Color(0xFF8D8E98),
                            activeTrackColor: Colors.white,
                            thumbColor: Colors.white,
                            overlayColor: const Color(0x29EB1555),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10.0),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 20.0),
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
                  //SizedBox(height: 1.h),
                  ReusableCard(
                    gradient: kActiveCardColour,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'AGE',
                          style: kLabelTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              age.toString(),
                              style: kNumberTextStyle.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'years',
                              style: kLabelTextStyle.copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        //SizedBox(height: 1.h),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            inactiveTrackColor: const Color(0xFF8D8E98),
                            activeTrackColor: Colors.white,
                            thumbColor: Colors.white,
                            overlayColor: const Color(0x29EB1555),
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 10.0),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 20.0),
                          ),
                          child: Slider(
                            value: age.toDouble(),
                            min: 15.0,
                            max: 80.0,
                            onChanged: (double newValue) {
                              updateAge(newValue);
                            },
                          ),
                        ),
                      ],
                    ),
                    onPress: () {},
                  ),
                  //SizedBox(height: 1.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 15,
                      backgroundColor: const Color(0xff61045f),
                      shadowColor: AppColors.LIGHT_BLACK,
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
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
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffaa076b),
                            Color(0xff61045f),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        constraints:
                            BoxConstraints(minWidth: 200.w, minHeight: 50.h),
                        alignment: Alignment.center,
                        child: Text(
                          'CALCULATE',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
