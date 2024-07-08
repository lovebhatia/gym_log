class WorkoutProgramModel {
  final int id;
  final String workoutProgramName;
  final String createdTime;
  final String publishedBy;
  final String level;
  final String mainGoal;
  final String daysPerWeek;
  final String durationRange;
  final String description;
  final double rating;
  final int sequence;
  final String imageName;
  final String icon;

  WorkoutProgramModel(
      {required this.id,
      required this.workoutProgramName,
      required this.createdTime,
      required this.publishedBy,
      required this.level,
      required this.mainGoal,
      required this.daysPerWeek,
      required this.durationRange,
      required this.description,
      required this.rating,
      required this.sequence,
      required this.imageName,
      required this.icon});

  factory WorkoutProgramModel.fromJson(Map<String, dynamic> json) {
    return WorkoutProgramModel(
        id: json['id'],
        workoutProgramName: json['workoutProgramName'] ?? "",
        createdTime: json['createdTime'] ?? "",
        publishedBy: json['publishedBy'] ?? "",
        level: json['level'] ?? "",
        mainGoal: json['mainGoal'] ?? "",
        daysPerWeek: json['daysPerWeek'] ?? "",
        durationRange: json['durationRange'] ?? "",
        description: json['description'] ?? "",
        rating: json['rating'] ?? "",
        sequence: json['sequence'] ?? "",
        imageName: json['imageName'] ?? "",
        icon: json['icon'] ?? "");
  }
}
