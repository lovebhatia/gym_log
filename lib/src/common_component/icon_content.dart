import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constants.dart';

class IconContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final double iconSize; // Add this parameter

  IconContent(
      {required this.icon,
      required this.label,
      this.iconSize = 40.0}); // Default iconSize

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: iconSize, // Use the iconSize parameter
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          label,
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}
