import'package:moghtarib/core/cache/cache_helper.dart';
import'package:moghtarib/core/network/end_points.dart';
import'package:dio/dio.dart';
import'package:moghtarib/core/cache/cache_keys.dart';
import'package:dartz/dartz.dart';


abstract class ApiHelper {
  static final Dio dio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Debug logs (optional)
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('HEADERS: ${options.headers}');
          print('DATA: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) async {
          final errorMsg = _extractMessage(error);

          final requestOptions = error.requestOptions;
          
          if (requestOptions.path.contains(EndPoints.login) || 
      requestOptions.path.contains(EndPoints.register)) {
    return handler.next(error); // مرري الخطأ الحقيقي القادم من السيرفر فوراً بدون لف ودوران
  }

          if (errorMsg != null && errorMsg.contains('Token has expired.')) {
            try {
              final dioRefresh = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));
              final refreshToken = CacheHelper.getValue(CacheKeys.refreshToken);

              // If refresh endpoint isn't configured in your EndPoints, skip refresh flow.
              if (EndPoints.refresh == null) {
                return handler.next(error);
              }

              final refreshResponse = await dioRefresh.post(
                EndPoints.refresh!,

                options: Options(
                  headers: {
                    'Authorization': 'Bearer $refreshToken',
                  },
                ),
              );

              if (refreshResponse.statusCode == 200 &&
                  refreshResponse.data != null) {
                final map = refreshResponse.data as Map<String, dynamic>;
                final newAccessToken = map['access_token'] as String;

                await CacheHelper.setValue(
                  key: CacheKeys.accessToken,
                  value: newAccessToken,
                );

                // --- Clone the request options safely ---
                final retryOptions = Options(
                  method: requestOptions.method,
                  headers: Map<String, dynamic>.from(
                    requestOptions.headers,
                  ),
                  responseType: requestOptions.responseType,
                  contentType: requestOptions.contentType,
                  followRedirects: requestOptions.followRedirects,
                  validateStatus: requestOptions.validateStatus,
                  receiveTimeout: requestOptions.receiveTimeout,
                  sendTimeout: requestOptions.sendTimeout,
                  extra: requestOptions.extra,
                  // Keep existing query params/form-data/etc via requestOptions
                );

                retryOptions.headers ??= {};
                retryOptions.headers!['Authorization'] = 'Bearer $newAccessToken';

                // Retry the same request; do NOT rebuild FormData
                final newResponse = await dio.request<dynamic>(
                  requestOptions.path,
                  data: requestOptions.data,
                  queryParameters: requestOptions.queryParameters,
                  options: retryOptions,
                  cancelToken: requestOptions.cancelToken,
                  onReceiveProgress: requestOptions.onReceiveProgress,
                  onSendProgress: requestOptions.onSendProgress,
                );

                return handler.resolve(newResponse);
              }
            } catch (e) {
              print("Refresh token failed: $e");
              // Fall through to original error
            }
          }

          return handler.next(error);
        },
      ),
    );

  static String? _extractMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map) {
      final msg = data['message'];
      return msg?.toString();
    }
    return error.message;
  }
  static String _handleDioError(dynamic e) {
    print("❌ FULL DIO ERROR: ${e.toString()}");
    String errorMsg = 'Something went wrong';

    if (e is DioException) {
      final data = e.response?.data;

      if (data != null) {
        // 🚨 السطر الأهم: سيطبع لك في الـ Console تفاصيل الـ Validation القادمة من السيرفر بالملي
        print("🚨 SERVER VALIDATION RESPONSE: $data");

        if (data is Map) {
          // إذا كان السيرفر يرسل الأخطاء داخل كائن "errors" (وهو الشائع في ASP.NET و Laravel)
          if (data['errors'] != null) {
            return _extractErrorsFromMap(data['errors']);
          }
          // إذا كان هناك رسالة مباشرة
          if (data['message'] != null) {
            return data['message'].toString();
          }
          // إذا كان الـ Map نفسه يحتوي على رسائل الخطأ مباشرة
          return data.values.first.toString();
        } else if (data is String) {
          return data;
        }
      } else {
        errorMsg = e.message ?? errorMsg;
      }
    }
    return errorMsg;
  }

  // دالة مساعدة لاستخراج أول خطأ يظهر للمستخدم بشكل نظيف
  static String _extractErrorsFromMap(dynamic errors) {
    if (errors is Map) {
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
      return firstError.toString();
    }
    return errors.toString();
  }
  // static String _handleDioError(dynamic e) {
  //   // print(e.toString());
  //   print("❌ FULL DIO ERROR: ${e.toString()}");
  //   String errorMsg = 'Something went wrong';
  //   if (e is DioException) {
  //     final data = e.response?.data;
  //     // if (data != null && data is Map) {
  //     if (data != null) {
  //       // 🚨 السطر الأهم: سيطبع لك في الـ Console تفاصيل الـ Validation القادمة من السيرفر بالملي
  //       print("🚨 SERVER VALIDATION RESPONSE: $data")
  //       errorMsg = data['message']?.toString() ?? errorMsg;
  //     } else {
  //       errorMsg = e.message ?? errorMsg;
  //     }
  //   }
  //   return errorMsg;
  // }

  static Future<Either<String, Map<String, dynamic>>> post({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      String? accessToken;
      if (isProtected) {
        accessToken = CacheHelper.getValue(CacheKeys.accessToken) as String?;
      }

      final response = await dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(
          contentType: isFormData ? 'multipart/form-data' : 'application/json',
          headers: {
            if (isProtected && accessToken != null) 'Authorization': 'Bearer $accessToken',
            ...?headers,
          },
        ),
      );

      return right(response.data as Map<String, dynamic>);
    } catch (e) {
      return left(_handleDioError(e));
    }
  }

  static Future<Either<String, Map<String, dynamic>>> get({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    bool isProtected = true,
  }) async {
    try {
      String? accessToken;
      if (isProtected) {
        accessToken = CacheHelper.getValue(CacheKeys.accessToken) as String?;
      }

      final response = await dio.get(
        endPoint,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            if (isProtected && accessToken != null) 'Authorization': 'Bearer $accessToken',
            ...?headers,
          },
        ),
      );

      return right(response.data as Map<String, dynamic>);
    } catch (e) {
      return left(_handleDioError(e));
    }
  }

  static Future<Either<String, Map<String, dynamic>>> put({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      String? accessToken;
      if (isProtected) {
        accessToken = CacheHelper.getValue(CacheKeys.accessToken) as String?;
      }

      final response = await dio.put(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(
          headers: {
            if (isProtected && accessToken != null) 'Authorization': 'Bearer $accessToken',
            ...?headers,
          },
        ),
      );

      return right(response.data as Map<String, dynamic>);
    } catch (e) {
      return left(_handleDioError(e));
    }
  }

  static Future<Either<String, Map<String, dynamic>>> delete({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    try {
      String? accessToken;
      if (isProtected) {
        accessToken = CacheHelper.getValue(CacheKeys.accessToken) as String?;
      }

      final response = await dio.delete(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(
          headers: {
            if (isProtected && accessToken != null) 'Authorization': 'Bearer $accessToken',
            ...?headers,
          },
        ),
      );

      return right(response.data as Map<String, dynamic>);
    } catch (e) {
      return left(_handleDioError(e));
    }
  }
}