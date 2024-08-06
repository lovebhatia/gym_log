import 'dart:convert';
import 'package:gym_log_exercise/src/model/bmi/bmi_model.dart';
import 'package:gym_log_exercise/src/model/exercise/exercise_per_workout_model.dart';
import 'package:gym_log_exercise/src/providers/baseProvider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/consts.dart';

class BmiService {
  Future<BMIModel> fetchBmiPerUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData')!);

    String token = extractedUserData['token'];
    int userId = extractedUserData['userId'];
    final response = await http.get(
      Uri.parse('$DEFAULT_SERVER_PROD1/bmi/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      BMIModel bmiModel = jsonDecode(response.body);
      return bmiModel;
    } else {
      throw Exception('Failed to load BMi');
    }
  }
}
