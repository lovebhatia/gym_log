import 'dart:convert';
import 'package:gym_log_exercise/src/model/workout/workout_model.dart';
import 'package:gym_log_exercise/src/model/workout/workout_program_model.dart';
import 'package:gym_log_exercise/src/providers/baseProvider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/consts.dart';

class WorkoutProgramService {
  late BaseProvider _baseProvider;

  Future<List<WorkoutModel>> fetchWorkout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);
    String token = extractedUserData['token'];
    final response = await http.get(
      Uri.parse('$DEFAULT_SERVER_PROD1/workout/allWorkouts'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<WorkoutModel> exerciseDayList =
          data.map((json) => WorkoutModel.fromJson(json)).toList();
      return exerciseDayList;
    } else {
      throw Exception('Failed to load exerciseDay');
    }
  }

  Future<List<WorkoutProgramModel>> fetchWorkoutProgram() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);
    String token = extractedUserData['token'];
    final response = await http.get(
      Uri.parse('$DEFAULT_SERVER_PROD1/program/allPrograms'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<WorkoutProgramModel> workoutProgramList =
          data.map((json) => WorkoutProgramModel.fromJson(json)).toList();
      return workoutProgramList;
    } else {
      throw Exception('Failed to load exerciseDay');
    }
  }
}
