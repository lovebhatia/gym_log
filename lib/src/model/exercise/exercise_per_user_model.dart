import 'package:gym_log_exercise/src/model/exercise/rep_record_per_user_model.dart';

class ExercisePerUserModel {
  final int id;
  final String exerciseName;
  final DateTime createdAt;
  final List<RepsRecordPerUserModel> exerciseSetRecords;

  ExercisePerUserModel({
    required this.id,
    required this.exerciseName,
    required this.createdAt,
    required this.exerciseSetRecords,
  });

  factory ExercisePerUserModel.fromJson(Map<String, dynamic> json) {
    var list = json['exerciseSetRecords'] as List;
    List<RepsRecordPerUserModel> exerciseSetRecordList =
        list.map((i) => RepsRecordPerUserModel.fromJson(i)).toList();

    return ExercisePerUserModel(
      id: json['id'],
      exerciseName: json['exerciseName'],
      createdAt: DateTime.parse(json['createdAt']),
      exerciseSetRecords: exerciseSetRecordList,
    );
  }
}
