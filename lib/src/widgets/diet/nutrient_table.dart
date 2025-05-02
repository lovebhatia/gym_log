import 'package:flutter/material.dart';

class NutrientTable extends StatelessWidget {
  final Map<String, double> nutrients;

  const NutrientTable({required this.nutrients, super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.white),
      children: [
        TableRow(
          children: [
            _tableCell('Nutrient', isHeader: true),
            _tableCell('Amount (g)', isHeader: true),
          ],
        ),
        ...nutrients.entries.map((nutrient) {
          return TableRow(
            children: [
              _tableCell(nutrient.key),
              _tableCell(nutrient.value.toStringAsFixed(2)),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.white)),
    );
  }
}
