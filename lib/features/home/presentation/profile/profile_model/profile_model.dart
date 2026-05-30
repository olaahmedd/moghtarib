class ChangePasswordResponse {
  final int? statusCode;
  final String message;

  ChangePasswordResponse({
    this.statusCode,
    required this.message,
  });

  // بنحتاجها عشان نستقبل البيانات من السيرفر ونحولها لـ Object نشتغل بيه
  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      statusCode: json['statusCode'] as int?,
      message: json['message'] ?? '',
    );
  }
}