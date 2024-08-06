import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({
    required this.icon,
    required this.onPressed,
    //required this.iconSize, // Added iconSize parameter
  });

  final IconData icon;
  final Function onPressed;
  //final double iconSize; // Added iconSize field

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      onPressed: () => onPressed(), // Changed to correctly call the function
      constraints: BoxConstraints.tightFor(
        width: 56.0.w,
        height: 56.0.h,
      ),
      shape: const CircleBorder(),
      fillColor: Colors.white,
      child: Icon(
        icon,
        //size: iconSize, // Set icon size here
      ),
    );
  }
}
