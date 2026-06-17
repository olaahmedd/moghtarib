class SanaieeModel {
  final String id; 
  final String? userName;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? nationalId;
  final String? whatsappNumber;
  final String? websiteURL;
  final String? type;
  final String? departmentId;
  final String? departmentName;

  const SanaieeModel({
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
    this.departmentId,
    this.departmentName
  });

  factory SanaieeModel.fromJson(Map<String, dynamic> json) {
    
    final dynamic idRaw = json['id'] ?? json['Id'] ?? json['userId'];
    final String parsedId = idRaw?.toString() ?? '';

    return SanaieeModel(
      id: parsedId, 
      userName: json['userName']?.toString(),
      email: json['email']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      nationalId: json['nationalId']?.toString(),
      whatsappNumber: json['whatsappNumber']?.toString(),
      websiteURL: json['websiteURL']?.toString(),
      type: json['type']?.toString(),
      departmentId: json['departmentId']?.toString(),
      departmentName: json['departmentName']?.toString()
    );
  }
}