class BMIModel {
  final int id;
  final int userId;
  final String bmi;

  BMIModel({
    required this.id,
    required this.userId,
    required this.bmi,
  });

  factory BMIModel.fromJson(Map<String, dynamic> json) {
    return BMIModel(
        id: json['id'], userId: json['userId'] ?? "", bmi: json['bmi'] ?? "");
  }
}
