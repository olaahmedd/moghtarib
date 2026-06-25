
import 'package:dio/dio.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/core/cache/cache_keys.dart';
import 'package:moghtarib/core/network/end_points.dart';
import 'package:moghtarib/features/home/presentation/profile/model/user_profile_model.dart';

class ProfileRepo {
  final Dio _dio;

  // هنا بنباصي الـ Dio أو نخليه يعمل Initialize لنفسه مع الـ BaseUrl الموحد بتاعك
  ProfileRepo({Dio? dio}) : _dio = dio ?? Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl, // تأكدي إن المتغير ده بيقشر على السيرفر الصح بتاعك
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // دالة جلب بيانات المستخدم الحالي بالـ Token
  Future<UserProfileModel> getCurrentUser() async {
    try {
      // لقط الـ Token المتسيف في الـ Cache عندك أثناء الـ Login
      final String? token = CacheHelper.getValue(CacheKeys.accessToken)?.toString();

      final response = await _dio.get(
        '/api/Account/GetCurrentUser',
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
      } else {
        throw Exception('فشل في جلب بيانات المستخدم من السيرفر');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data?['message'] ?? 'خطأ من السيرفر: ${e.response?.statusCode}');
      }
      throw Exception('حدث خطأ في الاتصال بالشبكة: ${e.message}');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: ${e.toString()}');
    }
  }
}