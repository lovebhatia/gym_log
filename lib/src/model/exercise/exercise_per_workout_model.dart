class ExercisesPerWorkoutModel {
  final int id;
  final String exerciseName;
  final String createdTime;
  final String setRange;
  final String gifName;
  final String exerciseDescription;

  ExercisesPerWorkoutModel(
      {required this.id,
      required this.exerciseName,
      required this.createdTime,
      required this.setRange,
      required this.gifName,
      required this.exerciseDescription});

  factory ExercisesPerWorkoutModel.fromJson(Map<String, dynamic> json) {
    return ExercisesPerWorkoutModel(
      id: json['id'],
      exerciseName: json['exerciseName'] ?? "",
      createdTime: json['createdTime'] ?? "",
      setRange: json['setRange'] ?? "",
      gifName: json['gifName'] ?? "",
      exerciseDescription: json['exerciseDescription'] ?? "",
    );
  }
}
