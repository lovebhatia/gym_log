import 'dart:convert';
import 'package:gym_log_exercise/src/model/exercise/exercise_per_user_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/consts.dart';
import '../providers/baseProvider.dart';

class RepsService {
  Future<bool> createExerciseSet(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);
    String token = extractedUserData['token'];
    final body = json.encode(data);
    final response = await http.post(
      Uri.parse('$DEFAULT_SERVER_PROD1/exercise-per-user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('in tru');
      return true; // Success
    } else {
      return false; // Failure
    }
  }

  Future<List<ExercisePerUserModel>> fetchExerciseSets(
      exerciseName, userID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(pref.getString('userData')!);
    String token = extractedUserData['token'];
    var userId = extractedUserData['userId'];

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final response = await http.get(
        Uri.parse('$DEFAULT_SERVER_PROD1/exercise-per-user')
            .replace(queryParameters: {
          'userId': userId.toString(),
          'exerciseName': exerciseName,
          'date': formattedDate,
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          List<dynamic> data = jsonDecode(response.body);
          List<ExercisePerUserModel> exerciseSets =
              data.map((json) => ExercisePerUserModel.fromJson(json)).toList();
          return exerciseSets;
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Failed to load exercise sets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<ExercisePerUserModel>> fetchRepsHistory(
      exerciseName, userID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(pref.getString('userData')!);
    String token = extractedUserData['token'];
    var userId = extractedUserData['userId'];

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final response = await http.get(
        Uri.parse('$DEFAULT_SERVER_PROD1/exercise-per-user/history').replace(
            queryParameters: {
              'userId': userId.toString(),
              'exerciseName': exerciseName
            }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          List<dynamic> data = jsonDecode(response.body);
          List<ExercisePerUserModel> exerciseSetsHistory =
              data.map((json) => ExercisePerUserModel.fromJson(json)).toList();
          return exerciseSetsHistory;
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Failed to load exercise sets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
