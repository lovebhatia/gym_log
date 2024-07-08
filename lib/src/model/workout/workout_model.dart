class WorkoutModel {
  final int id;
  final String workout;
  final String createdTime;
  final String imageName;
  final String showSequence;

  WorkoutModel(
      {required this.id,
      required this.workout,
      required this.createdTime,
      required this.imageName,
      required this.showSequence});

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
        id: json['id'],
        workout: json['workout'] ?? "",
        createdTime: json['createdTime'] ?? "",
        imageName: json['imageName'] ?? "",
        showSequence: json['showSequence']);
  }
}
