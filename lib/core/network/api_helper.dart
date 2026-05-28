import'package:moghtarib/core/cache/cache_helper.dart';
import'package:moghtarib/core/network/end_points.dart';
import'package:dio/dio.dart';
import'package:moghtarib/core/cache/cache_keys.dart';
import'package:dartz/dartz.dart';


// تأكد من استيراد الملفات الأخرى الخاصة بك مثل EndPoints و CacheHelper هنا

abstract class ApiHelper {
  static final Dio dio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
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
            return handler.next(error); 
          }

          if (errorMsg != null && errorMsg.contains('Token has expired.')) {
            try {
              final dioRefresh = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));
              final refreshToken = CacheHelper.getValue(CacheKeys.refreshToken);

              if (EndPoints.refresh == null) {
                return handler.next(error);
              }

              final refreshResponse = await dioRefresh.post(
                EndPoints.refresh,
                options: Options(
                  headers: {
                    'Authorization': 'Bearer $refreshToken',
                  },
                ),
              );

              if (refreshResponse.statusCode == 200 && refreshResponse.data != null) {
                final map = refreshResponse.data as Map<String, dynamic>;
                final newAccessToken = map['access_token'] as String;

                await CacheHelper.setValue(
                  key: CacheKeys.accessToken,
                  value: newAccessToken,
                );

                final retryOptions = Options(
                  method: requestOptions.method,
                  headers: Map<String, dynamic>.from(requestOptions.headers),
                  responseType: requestOptions.responseType,
                  contentType: requestOptions.contentType,
                  followRedirects: requestOptions.followRedirects,
                  validateStatus: requestOptions.validateStatus,
                  receiveTimeout: requestOptions.receiveTimeout,
                  sendTimeout: requestOptions.sendTimeout,
                  extra: requestOptions.extra,
                );

                retryOptions.headers ??= {};
                retryOptions.headers!['Authorization'] = 'Bearer $newAccessToken';

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
        print("🚨 SERVER VALIDATION RESPONSE: $data");

        if (data is Map) {
          if (data['errors'] != null) {
            return _extractErrorsFromMap(data['errors']);
          }
          if (data['message'] != null) {
            return data['message'].toString();
          }
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

  // ✨ تعديل نوع الـ Return ليكون dynamic لجميع الدوال بالأسفل لتقبل الـ List والـ Map معاً

  static Future<Either<String, dynamic>> post({
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

      return right(response.data); // ✨ تم إزالة الـ Type Cast الإجباري
    } catch (e) {
      return left(_handleDioError(e));
    }
  }

  static Future<Either<String, dynamic>> get({
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

      return right(response.data); // ✨ تم إزالة الـ Type Cast الإجباري
    } catch (e) {
      return left(_handleDioError(e));
    }
  }

  static Future<Either<String, dynamic>> put({
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

      return right(response.data); // ✨ تم إزالة الـ Type Cast الإجباري
    } catch (e) {
      return left(_handleDioError(e));
    }
  }

  static Future<Either<String, dynamic>> delete({
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

      return right(response.data); // ✨ تم إزالة الـ Type Cast الإجباري
    } catch (e) {
      return left(_handleDioError(e));
    }
  }
}