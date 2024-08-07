class RepsRecordPerUserModel {
  final int id;
  final int? reps; // Make reps nullable
  final double? weight; // Make weight nullable
  final int set;
  final DateTime createdTime;

  RepsRecordPerUserModel({
    required this.id,
    this.reps, // Allow reps to be null
    this.weight, // Allow weight to be null
    required this.set,
    required this.createdTime,
  });

  factory RepsRecordPerUserModel.fromJson(Map<String, dynamic> json) {
    return RepsRecordPerUserModel(
      id: json['id'],
      reps: json['reps'] != null
          ? json['reps'] as int
          : null, // Handle null values
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null, // Handle null values and convert to double
      set: json['set'],
      createdTime: DateTime.parse(json['createdTime']),
    );
  }
}
