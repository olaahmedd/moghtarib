class UserModel {
  final String id; // ✨ تم التغيير إلى String لأن السيرفر يرسله UUID
  final String? userName;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? nationalId;
  final String? whatsappNumber;
  final String? websiteURL;
  final String? type;

  const UserModel({
    required this.id,
    this.userName,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.nationalId,
    this.whatsappNumber,
    this.websiteURL,
    this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // قراءة الـ id كـ String مباشرة وبأمان
    final dynamic idRaw = json['id'] ?? json['Id'] ?? json['userId'];
    final String parsedId = idRaw?.toString() ?? '';

    return UserModel(
      id: parsedId, // ✨ سيأخذ الـ UUID النصي الصحيح الآن
      userName: json['userName']?.toString(),
      email: json['email']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      nationalId: json['nationalId']?.toString(),
      whatsappNumber: json['whatsappNumber']?.toString(),
      websiteURL: json['websiteURL']?.toString(),
      type: json['type']?.toString(),
    );
  }
}

// class UserModel {
//   final int id;
//   final String? userName;
//   final String? email;
//   final String? firstName;
//   final String? lastName;
//   final String? phoneNumber;
//   final String? nationalId;
//   final String? whatsappNumber;
//   final String? websiteURL;
//   final String? type;

//   const UserModel({
//     required this.id,
//     this.userName,
//     this.email,
//     this.firstName,
//     this.lastName,
//     this.phoneNumber,
//     this.nationalId,
//     this.whatsappNumber,
//     this.websiteURL,
//     this.type,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     final dynamic idRaw = json['id'] ?? json['Id'];
//     final int parsedId = (idRaw is int) ? idRaw : int.tryParse(idRaw?.toString() ?? '') ?? 0;

//     return UserModel(
//       id: parsedId,
//       userName: json['userName']?.toString(),
//       email: json['email']?.toString(),
//       firstName: json['firstName']?.toString(),
//       lastName: json['lastName']?.toString(),
//       phoneNumber: json['phoneNumber']?.toString(),
//       nationalId: json['nationalId']?.toString(),
//       whatsappNumber: json['whatsappNumber']?.toString(),
//       websiteURL: json['websiteURL']?.toString(),
//       type: json['type']?.toString(),
//     );
//   }
// }