import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RepsRecordWidget extends StatelessWidget {
  final int index;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final ValueChanged<String> onWeightChanged;
  final ValueChanged<String> onRepsChanged;

  const RepsRecordWidget({
    super.key,
    required this.index,
    required this.weightController,
    required this.repsController,
    required this.onWeightChanged,
    required this.onRepsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[800]!),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 100,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        fillColor: Colors.grey[800],
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: onWeightChanged,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Kg',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 120,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: repsController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10.0),
                        fillColor: Colors.grey[800],
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: onRepsChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'REPS',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
