import 'dart:convert';
import 'package:gym_log_exercise/src/model/exercise/exercise_per_workout_model.dart';
import 'package:gym_log_exercise/src/providers/baseProvider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/consts.dart';

class ExercisePerWorkoutService {
  Future<List<ExercisesPerWorkoutModel>> fetchExercisesPerWorkout(
      exerciseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);

    String token = extractedUserData['token'];
    final response = await http.get(
      Uri.parse('$DEFAULT_SERVER_PROD1/workout/exercise/$exerciseId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<ExercisesPerWorkoutModel> exercises =
          data.map((json) => ExercisesPerWorkoutModel.fromJson(json)).toList();
      return exercises;
    } else {
      throw Exception('Failed to load exerciseDay');
    }
  }
}
