import 'package:flutter/material.dart';

class DailySummaryTable extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> mealEntries;

  const DailySummaryTable({required this.mealEntries, super.key});

  @override
  Widget build(BuildContext context) {
    double totalProtein = 0, totalCarbs = 0, totalCalories = 0;

    mealEntries.values.expand((meal) => meal).forEach((entry) {
      totalProtein += entry['nutrients']['Protein'] ?? 0;
      totalCarbs += entry['nutrients']['Carbs'] ?? 0;
      totalCalories += entry['nutrients']['Calories'] ?? 0;
    });

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              'Daily Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white),
            _tableCell('Total Protein: ${totalProtein.toStringAsFixed(2)}g'),
            _tableCell('Total Carbs: ${totalCarbs.toStringAsFixed(2)}g'),
            _tableCell(
                'Total Calories: ${totalCalories.toStringAsFixed(2)} kcal'),
          ],
        ),
      ),
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
