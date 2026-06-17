import 'package:dartz/dartz.dart';
import 'package:moghtarib/core/network/api_helper.dart';
import 'package:moghtarib/core/network/end_points.dart';

class ChangePasswordRequestBody {
  final String email;
  final String password;

  ChangePasswordRequestBody({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password, 
    };
  }
}

class UserRepo {
  
  Future<Either<String, String>> changePassword({
    required String email, 
    required String newPassword,
  }) async {
    try {
      final requestBody = ChangePasswordRequestBody(
        email: email,
        password: newPassword,
      );

      
      final result = await ApiHelper.put(
        endPoint: EndPoints.changePas, 
        data: requestBody.toJson(),
        isProtected: true, 
      );

      return result.fold(
        (error) => Left(error),
        (data) {
          
          if (data is Map && data['message'] != null) {
            return Right(data['message'].toString());
          }
          return Right('Password changed successfully');
        },
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}