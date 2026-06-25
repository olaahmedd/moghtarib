class ReportModel {
  final int? id;
  final String? userId;
  final String? userName;
  final String? text;

  ReportModel({this.id, this.userId, this.userName, this.text});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
    );
  }
}