import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gym_log_exercise/src/model/exercise/exercise_per_workout_model.dart';
import 'package:gym_log_exercise/src/model/workout/workout_model.dart';
import 'package:gym_log_exercise/src/model/workout/workout_program_model.dart';
import 'package:gym_log_exercise/src/providers/baseProvider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/consts.dart';

class WorkoutPlanService {
  late BaseProvider _baseProvider;

  Future<List<ExercisesPerWorkoutModel>> fetchExercises(
      int userId, int workoutProgramId, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);
    var userId = extractedUserData['userId'];
    final url = Uri.parse(
        "$DEFAULT_SERVER_PROD1/plan/user/$userId/workout/$workoutProgramId/exercises/$date");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData
            .map((e) => ExercisesPerWorkoutModel.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to load exercises");
      }
    } catch (e) {
      print("Error fetching exercises: $e");
      return [];
    }
  }
}
