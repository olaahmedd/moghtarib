class ChangePasswordResponse {
  final int? statusCode;
  final String message;

  ChangePasswordResponse({
    this.statusCode,
    required this.message,
  });

  
  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      statusCode: json['statusCode'] as int?,
      message: json['message'] ?? '',
    );
  }
}