import 'package:flutter/material.dart';
import 'package:gym_log_exercise/src/widgets/diet/date_selector.dart';

import '../../widgets/diet/daily_summary.dart';
import '../../widgets/diet/meal_section.dart';

class DietTrackingScreen extends StatefulWidget {
  @override
  _DietTrackingScreenState createState() => _DietTrackingScreenState();
}

class _DietTrackingScreenState extends State<DietTrackingScreen> {
  final Map<DateTime, Map<String, List<Map<String, dynamic>>>> _mealEntries =
      {};

  DateTime _selectedDate = DateTime.now();

  /// Ensures entries exist for the selected date
  Map<String, List<Map<String, dynamic>>> get _selectedDateMeals {
    return _mealEntries.putIfAbsent(
      _selectedDate,
      () => {
        'Breakfast': [],
        'Lunch': [],
        'Dinner': [],
        'Snacks': [],
      },
    );
  }

  void _updateData() {
    setState(() {}); // Trigger UI refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Diet Tracking'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          DateSelector(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._selectedDateMeals.keys.map((meal) => MealSection(
                        meal: meal,
                        mealEntries: _selectedDateMeals,
                        onUpdate: _updateData,
                      )),
                  DailySummaryTable(mealEntries: _selectedDateMeals),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
