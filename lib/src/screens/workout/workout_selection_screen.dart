import '../../animations/transitions.dart';
import '../../resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'workout_at_gym_screen.dart';

class WorkoutSelectionScreen extends StatefulWidget {
  const WorkoutSelectionScreen({super.key});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    // Dummy data for the exercises
    final List<Map<String, dynamic>> exercises = [
      {
        'exercise': 'Bench Press',
        'sets': [
          {'weight': '80kg', 'reps': '10', 'date': '2024-07-04'},
          {'weight': '85kg', 'reps': '8', 'date': '2024-07-04'}
        ]
      },
      {
        'exercise': 'Squat',
        'sets': [
          {'weight': '100kg', 'reps': '12', 'date': '2024-07-04'},
          {'weight': '105kg', 'reps': '10', 'date': '2024-07-04'}
        ]
      }
    ];

    return Container(
      color: AppColors.BLACK,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.LIGHT_BLACK,
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
                        'Work',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'Out',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff8E2DE2),
                          letterSpacing: 3,
                        ),
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
                    'Hey There,',
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
                    'Choose your Work Out plan .',
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
                        SlideLeftTransition(
                          const WorkoutAtGymScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 150.h,
                      padding: EdgeInsets.all(10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff8E2DE2),
                            Color(0xff4A00E0),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Workout At',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          Text(
                            'Gym',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 22.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Exercises Performed',
                        style: GoogleFonts.lato(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: exercises.map((exercise) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise['exercise'] as String,
                                    style: GoogleFonts.lato(
                                      fontSize: 18.sp,
                                      color: const Color(0xff8E2DE2),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Table(
                                    border: const TableBorder(
                                      horizontalInside: BorderSide(
                                        color: Colors.white,
                                        width: 0.5,
                                      ),
                                    ),
                                    children: [
                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: const Color(0xff4A00E0),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        children: [
                                          _buildTableCell('Weight', true),
                                          _buildTableCell('Reps', true),
                                          _buildTableCell('Date', true),
                                        ],
                                      ),
                                      ...(exercise['sets']
                                              as List<Map<String, String>>)
                                          .map<TableRow>((set) {
                                        return TableRow(
                                          children: [
                                            _buildTableCell(
                                                set['weight']!, false),
                                            _buildTableCell(
                                                set['reps']!, false),
                                            _buildTableCell(
                                                set['date']!, false),
                                          ],
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the history page
                            Navigator.push(
                              context,
                              SlideLeftTransition(
                                HistoryPage(), // Replace with your history page
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8E2DE2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(
                            'View History',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableCell _buildTableCell(String text, bool isHeader) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            color: isHeader ? Colors.white : Colors.white70,
            fontSize: isHeader ? 16.sp : 14.sp,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise History'),
        backgroundColor: const Color(0xff8E2DE2),
      ),
      body: const Center(
        child: Text('History Page Content'),
      ),
    );
  }
}
