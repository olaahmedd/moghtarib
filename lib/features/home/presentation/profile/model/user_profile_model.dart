class UserProfileModel {
  final String? id;
  final String? userName;
  final String? email;
  final String? role;
final String? token;
  UserProfileModel({this.id, this.userName, this.email, this.role, this.token});
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString(),
      userName: json['userName']?.toString(),
      email: json['email']?.toString(),
      role: json['role']?.toString(),
      token: json['token']?.toString()
    );
  }
}