// import'package:dio/dio.dart';
// import'package:moghtarib/core/cache/cache_helper.dart';
// import'package:moghtarib/core/network/end_points.dart';
// import'package:moghtarib/core/cache/cache_keys.dart';
// import'package:dartz/dartz.dart';
// import'package:moghtarib/core/network/api_helper.dart';
// import 'package:moghtarib/core/cache/cache_helper.dart';
// import 'package:moghtarib/core/cache/cache_keys.dart';
// import 'package:moghtarib/core/network/end_points.dart';
// import 'package:moghtarib/features/auth/model/user_model.dart';
// import 'package:dartz/dartz.dart';

// class AuthRepo {
//   Future<Either<String, UserModel>> login(
//       {required String email, required String password}) async {//لازم ندخل username,password
//     // right
//     print("DEBUG LOGIN DATA: {'email': $email, 'password': $password}");
//     var response = await ApiHelper.post(
//       endPoint: EndPoints.login,
//       // isFormData: true,
//       data: {'email': email, 'password': password},//ببعت البيانات لل api 
//     );
//     return response.fold((error) {
//       print("DEBUG LOGIN ERROR FROM SERVER: $error");
//       return left(error);
//     }, (map) async {
//       print("DEBUG LOGIN SUCCESS MAP: $map");
//       await CacheHelper.setValue(
//           key: CacheKeys.accessToken, value: map[CacheKeys.accessToken]);//خزنت التوكن عشان هحتاجه
//       await CacheHelper.setValue(
//           key: CacheKeys.refreshToken, value: map[CacheKeys.refreshToken]);//خزنته برضو عشان هحتاجه لو التوكن بقى expired

//       return right(UserModel.fromJson(map['user']));//دي البيانات اللي محتاجاها بس من ال response
//     });
//   }

//   Future<Either<String, String>> register({required String username,
//     required String firstName,
//     required String lastName,
//     required String email,
//     required String password,
//     required String nationalId,
//     required String type,
//     required String phoneNumber,
//     required String whatsappNumber,}) async {
//     print("DEBUG REGISTER DATA: {'email': $email, 'password': $password}");
//     var response = await ApiHelper.post(
//         endPoint: EndPoints.register,
        
//         data: {'email': email, 'password': password,'phoneNumber':phoneNumber,'userName': username,'firstName':firstName,'lastName':lastName,'nationalId':nationalId,'type':type,'whatsappNumber':whatsappNumber ,});

//     return response.fold((error) {
//       print("DEBUG REGISTER ERROR: $error");
//       return left(error);
//     }, (map) {
//       print("DEBUG REGISTER SUCCESS MAP: $map");
//       return right(map['message']);
//     });
//   }

//   }
import'package:moghtarib/core/cache/cache_helper.dart';
import'package:moghtarib/core/network/end_points.dart';
import'package:moghtarib/core/cache/cache_keys.dart';
import'package:dartz/dartz.dart';
import'package:moghtarib/core/network/api_helper.dart';

import 'package:moghtarib/features/auth/model/user_model.dart';


class AuthRepo {
  
  Future<String?> fetchUserRole() async {
    
    final token = CacheHelper.getValue(CacheKeys.accessToken) as String?;
    if (token == null || token.isEmpty) return null;

    final response = await ApiHelper.get(
      endPoint: EndPoints.userRoles,
      isProtected: true,
    );

    return response.fold(
      (error) => null,
      (map) {
        
        final dynamic role = map['role'] ?? map['Role'] ?? map['userRole'] ?? map['UserRole'];
        if (role == null) {
          // Sometimes backend returns a list
          final list = map['data'] ?? map['result'];
          if (list is List && list.isNotEmpty) {
            return list.first['role']?.toString();
          }
          return null;
        }
        return role.toString();
      },
    );
  }

  

  Future<Either<String, UserModel>> login({

    required String email, 
    required String password,
  }) async {
    print("DEBUG LOGIN DATA: {'email': $email, 'password': $password}");
    
    var response = await ApiHelper.post(
      endPoint: EndPoints.login,
      data: {'email': email, 'password': password},
    );

    return response.fold(
      (error) {
        print("DEBUG LOGIN ERROR FROM SERVER: $error");
        return left(error);
      }, 
      (map) async {
        print("DEBUG LOGIN SUCCESS MAP: $map");
        
        
        if (map[CacheKeys.accessToken] != null) {
          await CacheHelper.setValue(key: CacheKeys.accessToken, value: map[CacheKeys.accessToken]);
        }
        if (map[CacheKeys.refreshToken] != null) {
          await CacheHelper.setValue(key: CacheKeys.refreshToken, value: map[CacheKeys.refreshToken]);
        }

        
        return right(UserModel.fromJson(map['user'] ?? map)); 
      },
    );
  }

  
  Future<Either<String, UserModel>> register({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String nationalId,
    required String type,
    required String phoneNumber,
    required String whatsappNumber,
  }) async {
    print("DEBUG REGISTER DATA: {'email': $email, 'userName': $username}");
    
    var response = await ApiHelper.post(
      endPoint: EndPoints.register,
      data: {
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'userName': username,
        'firstName': firstName,
        'lastName': lastName,
        'nationalId': nationalId,
        'type': type,
        'whatsappNumber': whatsappNumber,
      },
    );

    return response.fold(
      (error) {
        print("DEBUG REGISTER ERROR: $error");
        return left(error);
      }, 
      (map) async {
        print("DEBUG REGISTER SUCCESS MAP: $map");
        
        
        if (map[CacheKeys.accessToken] != null || map['token'] != null) {
          await CacheHelper.setValue(
            key: CacheKeys.accessToken, 
            value: map[CacheKeys.accessToken] ?? map['token'],
          );
        }
        if (map[CacheKeys.refreshToken] != null || map['refreshToken'] != null) {
          await CacheHelper.setValue(
            key: CacheKeys.refreshToken, 
            value: map[CacheKeys.refreshToken] ?? map['refreshToken'],
          );
        }

    
        final userData = map['user'] != null ? map['user'] : map;
        return right(UserModel.fromJson(userData));
      },
    );
  }
}