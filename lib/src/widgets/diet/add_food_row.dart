import 'package:flutter/material.dart';

class AddFoodRow extends StatelessWidget {
  final String meal;
  final Map<String, List<Map<String, dynamic>>> mealEntries;
  final VoidCallback onUpdate;

  AddFoodRow({
    required this.meal,
    required this.mealEntries,
    required this.onUpdate,
  });

  final List<String> _foodItems = ['Oats', 'Eggs', 'Chicken', 'Rice', 'Milk'];
  final Map<String, Map<String, double>> _dummyNutrientData = {
    'Oats': {'Protein': 13, 'Carbs': 66, 'Calories': 389},
    'Eggs': {'Protein': 6, 'Carbs': 1, 'Calories': 68},
    'Chicken': {'Protein': 27, 'Carbs': 0, 'Calories': 165},
    'Rice': {'Protein': 2.7, 'Carbs': 28, 'Calories': 130},
    'Milk': {'Protein': 3.4, 'Carbs': 5, 'Calories': 42},
  };

  @override
  Widget build(BuildContext context) {
    String? selectedFood;
    TextEditingController quantityController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Food Item',
                  labelStyle: TextStyle(color: Colors.white)),
              items: _foodItems
                  .map((food) => DropdownMenuItem(
                      value: food,
                      child: Text(food,
                          style: const TextStyle(color: Colors.white))))
                  .toList(),
              onChanged: (value) {
                selectedFood = value;
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                  labelText: 'Quantity (g)',
                  labelStyle: TextStyle(color: Colors.white)),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              if (selectedFood != null && quantityController.text.isNotEmpty) {
                double quantity = double.tryParse(quantityController.text) ?? 0;
                if (quantity > 0) {
                  final nutrients = _dummyNutrientData[selectedFood!]!.map(
                      (key, value) => MapEntry(key, (value / 100) * quantity));

                  mealEntries[meal]!.add({
                    'food': selectedFood!,
                    'quantity': quantity,
                    'nutrients': nutrients,
                  });

                  onUpdate();
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
