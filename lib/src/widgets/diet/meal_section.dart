import 'package:flutter/material.dart';
import 'add_food_row.dart';
import 'nutrient_table.dart';

class MealSection extends StatelessWidget {
  final String meal;
  final Map<String, List<Map<String, dynamic>>> mealEntries;
  final VoidCallback onUpdate;

  const MealSection({
    required this.meal,
    required this.mealEntries,
    required this.onUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: Text(
          meal,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        children: [
          ...mealEntries[meal]!.map((entry) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${entry['food']} - ${entry['quantity']}g",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          mealEntries[meal]!.remove(entry);
                          onUpdate();
                        },
                      ),
                    ],
                  ),
                  NutrientTable(nutrients: entry['nutrients']),
                ],
              ),
            );
          }).toList(),
          AddFoodRow(meal: meal, mealEntries: mealEntries, onUpdate: onUpdate),
        ],
      ),
    );
  }
}
