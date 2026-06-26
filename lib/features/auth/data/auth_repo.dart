
import'package:moghtarib/core/cache/cache_helper.dart';
import'package:moghtarib/core/network/end_points.dart';
import'package:moghtarib/core/cache/cache_keys.dart';
import'package:dartz/dartz.dart';
import'package:moghtarib/core/network/api_helper.dart';
import 'package:moghtarib/features/auth/model/user_model.dart';

class AuthRepo {
  // ==================== FETCH USER ROLE ====================
  Future<String?> fetchUserRole() async {
    // Reads access token from cache and calls UserRoles endpoint.
    final token = CacheHelper.getValue(CacheKeys.accessToken) as String?;
    if (token == null || token.isEmpty) return null;

    final response = await ApiHelper.get(
      endPoint: EndPoints.userRoles,
      isProtected: true,
    );

    return response.fold(
      (error) => null,
      (map) {
        // Backend can return either a string or a model.
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

  // ==================== LOGIN FUNCTION ====================
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
        
        // حفظ التوكنز بأمان في الكاش
        if (map[CacheKeys.accessToken] != null) {
          await CacheHelper.setValue(key: CacheKeys.accessToken, value: map[CacheKeys.accessToken]);
        }
        if (map[CacheKeys.refreshToken] != null) {
          await CacheHelper.setValue(key: CacheKeys.refreshToken, value: map[CacheKeys.refreshToken]);
        }

        final userData = map['user'] ?? map;
        if (userData['id'] != null) {
          await CacheHelper.setValue(key: 'userId', value: userData['id'].toString());
        }
        if (userData['userName'] != null) {
          await CacheHelper.setValue(key: 'userName', value: userData['userName'].toString());
        }

        // إرجاع الموديل
        return right(UserModel.fromJson(map['user'] ?? map)); 
      },
    );
  }

  // ==================== REGISTER FUNCTION ====================
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
    String? departmentId, // استقبلنا المتغير هنا كـ اختياري من الـ Cubit
  }) async {
    print("DEBUG REGISTER DATA: {'email': $email, 'userName': $username, 'departmentId': $departmentId}");
    
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
        
        // 🎯 التعديل السحري: لو الحساب صنايعي ومختار قسم بيبعت الرقم، غير كده بيبعت null صريحة عشان السيرفر ما يضربش 500
        'departmentId': (type == 'Sanaiee' && departmentId != null && departmentId != "0") 
            ? (int.tryParse(departmentId)) 
            : null,
            
        'websiteURL': "string", // الكي دا السيرفر طالبه إجباري في السواجر فبنبعته كـ string افتراضي
      },
    );

    return response.fold(
      (error) {
        print("DEBUG REGISTER ERROR: $error");
        return left(error);
      }, 
      (map) async {
        print("DEBUG REGISTER SUCCESS MAP: $map");
        
        // حفظ التوكنز عند النجاح
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
        if (userData['id'] != null) {
          await CacheHelper.setValue(key: 'userId', value: userData['id'].toString());
        }
        if (userData['userName'] != null) {
          await CacheHelper.setValue(key: 'userName', value: userData['userName'].toString());
        }
        return right(UserModel.fromJson(userData));
      },
    );
  }

  Future<Either<String, List<dynamic>>> getDepartments() async {
    var response = await ApiHelper.get(
      endPoint: '/api/Department',
    );

    return response.fold(
      (error) {
        print("DEBUG GET DEPARTMENTS ERROR: $error");
        return left(error);
      },
      (listData) {
        print("DEBUG GET DEPARTMENTS SUCCESS: $listData");
        return right(listData as List<dynamic>);
      },
    );
  }
}