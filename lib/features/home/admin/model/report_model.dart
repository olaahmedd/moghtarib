import '../model/user_model.dart';
class User {
  final String? firstName;
  final String? whatsappNumber;

  User({this.firstName, this.whatsappNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      whatsappNumber: json['whatsappNumber'],
    );
  }
}
class ReportModel {
  final int? id;
  final String? text;
  final UserModel? user; 

  ReportModel({this.id, this.text, this.user});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      text: json['text'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}