class RepsRecordPerUserModel {
  final int id;
  final int reps;
  final double weight;
  final int set;
  final DateTime createdTime;

  RepsRecordPerUserModel({
    required this.id,
    required this.reps,
    required this.weight,
    required this.set,
    required this.createdTime,
  });

  factory RepsRecordPerUserModel.fromJson(Map<String, dynamic> json) {
    return RepsRecordPerUserModel(
      id: json['id'],
      reps: json['reps'],
      weight: json['weight'],
      set: json['set'],
      createdTime: DateTime.parse(json['createdTime']),
    );
  }
}
