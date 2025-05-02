import 'package:flutter/material.dart';

class SummaryTable extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> mealEntries;

  SummaryTable({required this.mealEntries});

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
      child: Column(children: [
        Text("Protein: ${totalProtein.toStringAsFixed(2)}g"),
        Text("Carbs: ${totalCarbs.toStringAsFixed(2)}g"),
        Text("Calories: ${totalCalories.toStringAsFixed(2)} kcal"),
      ]),
    );
  }
}
