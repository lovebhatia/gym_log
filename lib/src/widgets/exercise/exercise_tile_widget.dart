import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_log_exercise/src/widgets/exercise/exercise_details_widget.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constant.dart';

class ExerciseTileWidget extends StatelessWidget {
  final String exerciseName;
  final String sets;
  final String gif;
  final String description;
  final String selectedWorkout;

  const ExerciseTileWidget(
      {super.key,
      required this.exerciseName,
      required this.sets,
      required this.gif,
      required this.description,
      required this.selectedWorkout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 8),
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.LIGHT_BLACK,
        ),
        child: ListTile(
          onTap: () {
            showModalBottomSheet<dynamic>(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              context: context,
              builder: (BuildContext context) {
                return ExerciseDetailsWidget(
                    videoUrl: gif,
                    sets: sets,
                    exerciseName: exerciseName,
                    description: description,
                    selectedWorkout: selectedWorkout);
              },
            );
          },
          title: Text(
            exerciseName,
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(sets,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                )),
          ),
          trailing: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: NetworkImage(
                  '${AppConst.imageBaseUrl}${selectedWorkout.toLowerCase()}/${exerciseName.toLowerCase().replaceAll(' ', '_')}.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}
