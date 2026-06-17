import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/semantics.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/core/network/end_points.dart';
import '../model/add_apartment_model.dart';


// class ApartmentRepo {
//   final Dio _dio;

//   ApartmentRepo({Dio? dio}) : _dio = dio ?? Dio(
//     BaseOptions(
//       baseUrl: EndPoints.baseUrl, 
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//     ),
//   );

  
//   Future<Response> addApartment({
//     required AddApartmentModel apartment,
//     File? baseImage,
//     List<File>? additionalImages,
//   }) async {
//     try {
      
//       final Map<String, dynamic> queryParams = {
//         'City': apartment.city,
//         'Village': apartment.village,
//         'Location': apartment.location,
//         'Price': apartment.price,
//         'NumOfRooms': apartment.numOfRooms,
//         'Type': apartment.type,
//         'address_Lat': apartment.addressLat, 
//         'address_Lon': apartment.addressLon, 
//         'IsRent': apartment.isRent,
//       };

//             final FormData formData = FormData();

      
//       if (baseImage != null) {
//         formData.files.add(
//           MapEntry(
//             'BaseImage', 
//             await MultipartFile.fromFile(
//               baseImage.path, 
//               filename: baseImage.path.split('/').last,
//             ),
//           ),
//         );
//       }

      
//       if (additionalImages != null && additionalImages.isNotEmpty) {
//         for (var file in additionalImages) {
//           formData.files.add(
//             MapEntry(
//               'Images', 
//               await MultipartFile.fromFile(
//                 file.path, 
//                 filename: file.path.split('/').last,
//               ),
//             ),
//           );
//         }
//       }

      
//       print("🚀 Requesting Endpoint: ${EndPoints.getApartment}");
//       print("🚀 Query Params Sent: $queryParams");

      
//       final response = await _dio.post(
//         EndPoints.postApartment, 
//         queryParameters: queryParams, 
//         data: formData,               
//       );

//       return response;
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     } catch (e) {
//       throw Exception('حدث خطأ غير متوقع: $e');
//     }
//   }

  
//   String _handleDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//         return 'انتهت مهلة الاتصال بالسيرفر، يرجى المحاولة لاحقاً.';
//       case DioExceptionType.receiveTimeout:
//         return 'انتهت مهلة استقبال البيانات من السيرفر.';
//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//         String? serverMessage;

        
//         if (error.response?.data is Map<String, dynamic> || error.response?.data is Map) {
//           serverMessage = error.response?.data?['message'] ?? error.response?.data?['Message'];
//         } 
        
//         else if (error.response?.data is List) {
//           final listData = error.response?.data as List;
//           if (listData.isNotEmpty && listData.first is Map) {
//             serverMessage = listData.first['message'] ?? listData.first['Message'];
//           }
//         }

       
//         serverMessage ??= error.response?.statusMessage;

//         return 'خطأ من السيرفر ($statusCode): ${serverMessage ?? "فشل الطلب (تأكد من الـ Endpoint)"}';
        
//       case DioExceptionType.connectionError:
//         return 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.';
//       default:
//         return 'عذراً، حدث خطأ أثناء الاتصال بالشبكة.';
//     }
//   }
// }
//###################################################################################


class ApartmentRepo {
  final Dio _dio;

  ApartmentRepo({Dio? dio}) : _dio = dio ?? Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl, 
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<Response> addApartment({
    required AddApartmentModel apartment,
    File? baseImage,
    List<File>? additionalImages,
  }) async {
    try {
      // 1️⃣ حياكة الـ Query Parameters للنصوص والأرقام كما طلبها السيرفر في الـ Swagger
      final Map<String, dynamic> queryParams = {
        'City': apartment.city,
        'Village': apartment.village,
        'Location': apartment.location,
        'Price': apartment.price.toInt(),          
        'NumOfRooms': apartment.numOfRooms,  
        'Type': apartment.type,              
        'address_Lat': apartment.addressLat, 
        'address_Lon': apartment.addressLon, 
        'IsRent': apartment.isRent,          
      };

      // 2️⃣ الـ FormData مخصص للصور فقط
      final FormData formData = FormData();

      if (baseImage != null) {
        formData.files.add(
          MapEntry(
            'BaseImage', 
            await MultipartFile.fromFile(
              baseImage.path, 
              filename: baseImage.path.split('/').last,
            ),
          ),
        );
      }

      if (additionalImages != null && additionalImages.isNotEmpty) {
        for (var file in additionalImages) {
          formData.files.add(
            MapEntry(
              'Images', 
              await MultipartFile.fromFile(
                file.path, 
                filename: file.path.split('/').last,
              ),
            ),
          );
        }
      }

      // 3️⃣ جلب التوكن بشكل آمن تماماً وتفادي خطأ الـ Object Casting
      final dynamic rawToken = CacheHelper.getValue('token');
      final String token = rawToken != null ? rawToken.toString() : '';

      print("🚀 SENDING TO: ${EndPoints.baseUrl}${EndPoints.postApartment}");
      print("🚀 AUTH TOKEN LENGTH: ${token.length}");

      // 4️⃣ إرسال الطلب النهائي المدمج بالسيرفر أونلاين
      final response = await _dio.post(
        EndPoints.postApartment, 
        queryParameters: queryParams, // الحقول النصية في الـ URL
        data: formData,               // الصور في الـ Body
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      print("🚨 FULL SERVER ERROR: ${e.response?.data}");
      print("🚨 STATUS CODE: ${e.response?.statusCode}");
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'انتهت مهلة الاتصال بالسيرفر، يرجى المحاولة لاحقاً.';
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة استقبال البيانات من السيرفر.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        String? serverMessage;

        if (error.response?.data is Map<String, dynamic> || error.response?.data is Map) {
          serverMessage = error.response?.data?['message'] ?? error.response?.data?['Message'];
        } 
        else if (error.response?.data is List) {
          final listData = error.response?.data as List;
          if (listData.isNotEmpty && listData.first is Map) {
            serverMessage = listData.first['message'] ?? listData.first['Message'];
          }
        }

        serverMessage ??= error.response?.statusMessage;

        return 'خطأ من السيرفر ($statusCode): ${serverMessage ?? "فشل الطلب (تأكد من الـ Endpoint أو الـ Authorization)"}';
        
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.';
      default:
        return 'عذراً، حدث خطأ أثناء الاتصال بالشبكة.';
    }
  }
}