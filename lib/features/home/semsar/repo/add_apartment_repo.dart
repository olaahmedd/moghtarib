import 'dart:io';
import 'package:dio/dio.dart';
import 'package:moghtarib/core/network/end_points.dart';
import '../model/add_apartment_model.dart';

// 

// class ApartmentRepo {
//   final Dio _dio;

//   ApartmentRepo({Dio? dio}) : _dio = dio ?? Dio(
//     BaseOptions(
//       baseUrl: EndPoints.baseUrl, 
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//     ),
//   );

//   /// ✅ دالة إضافة شقة جديدة متوافقة مع الـ Swagger (البيانات في الرابط والصور في الـ Body)
//   Future<Response> addApartment({
//     required AddApartmentModel apartment,
//     File? baseImage,
//     List<File>? additionalImages,
//   }) async {
//     try {
//       // 1. بناء الـ Query Parameters مع التدقيق الشديد في حالة الأحرف (مطابق للـ Swagger)
//       final Map<String, dynamic> queryParams = {
//         'City': apartment.city,
//         'Village': apartment.village,
//         'Location': apartment.location,
//         'Price': apartment.price,
//         'NumOfRooms': apartment.numOfRooms,
//         'Type': apartment.type,
//         'address_Lat': apartment.addressLat, // 👈 حرف L كبير وليس صغير
//         'address_Lon': apartment.addressLon, // 👈 حرف L كبير وليس صغير
//         'IsRent': apartment.isRent,
//       };

//       // 2. بناء الـ FormData للصور فقط في الـ Body
//       final FormData formData = FormData();

//       // إضافة الصورة الأساسية (Key: BaseImage)
//       if (baseImage != null) {
//         formData.files.add(
//           MapEntry(
//             'BaseImage', // 👈 حرف B كبير وحرف I كبير مطابق للـ Swagger
//             await MultipartFile.fromFile(
//               baseImage.path, 
//               filename: baseImage.path.split('/').last,
//             ),
//           ),
//         );
//       }

//       // إضافة الصور الإضافية المتعددة (Key: Images)
//       if (additionalImages != null && additionalImages.isNotEmpty) {
//         for (var file in additionalImages) {
//           formData.files.add(
//             MapEntry(
//               'Images', // 👈 حرف I كبير مطابق للـ Swagger
//               await MultipartFile.fromFile(
//                 file.path, 
//                 filename: file.path.split('/').last,
//               ),
//             ),
//           );
//         }
//       }

//       // 🎯 طباعة آمنة للـ URL لتجنب خطأ الـ Subtype 'int' القديم
//       print("🚀 Requesting Endpoint: ${EndPoints.getApartment}");
//       print("🚀 Query Params Sent: $queryParams");

//       // 3. إرسال الطلب النهائي للسيرفر
//       final response = await _dio.post(
//         EndPoints.getApartment, 
//         queryParameters: queryParams, // النصوص في الـ URL (Query)
//         data: formData,               // الصور في الـ Body (Multipart)
//       );

//       return response;
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     } catch (e) {
//       throw Exception('حدث خطأ غير متوقع: $e');
//     }
//   }

//   /// دالة مساعدة لمعالجة أخطاء الـ Dio وتحويلها لنصوص واضحة
//   String _handleDioError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//         return 'انتهت مهلة الاتصال بالسيرفر، يرجى المحاولة لاحقاً.';
//       case DioExceptionType.receiveTimeout:
//         return 'انتهت مهلة استقبال البيانات من السيرفر.';
//       case DioExceptionType.badResponse:
//         final statusCode = error.response?.statusCode;
//         final serverMessage = error.response?.data?['message'] ?? error.response?.statusMessage;
//         return 'خطأ من السيرفر ($statusCode): ${serverMessage ?? "فشل الطلب"}';
//       case DioExceptionType.connectionError:
//         return 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.';
//       default:
//         return 'عذراً، حدث خطأ أثناء الاتصال بالشبكة.';
//     }
//   }
// }
class ApartmentRepo {
  final Dio _dio;

  ApartmentRepo({Dio? dio}) : _dio = dio ?? Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl, 
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// ✅ دالة إضافة شقة جديدة متوافقة مع الـ Swagger (البيانات في الرابط والصور في الـ Body)
  Future<Response> addApartment({
    required AddApartmentModel apartment,
    File? baseImage,
    List<File>? additionalImages,
  }) async {
    try {
      // 1. بناء الـ Query Parameters مع التدقيق الشديد في حالة الأحرف (مطابق للـ Swagger)
      final Map<String, dynamic> queryParams = {
        'City': apartment.city,
        'Village': apartment.village,
        'Location': apartment.location,
        'Price': apartment.price,
        'NumOfRooms': apartment.numOfRooms,
        'Type': apartment.type,
        'address_Lat': apartment.addressLat, 
        'address_Lon': apartment.addressLon, 
        'IsRent': apartment.isRent,
      };

      // 2. بناء الـ FormData للصور فقط في الـ Body
      final FormData formData = FormData();

      // إضافة الصورة الأساسية (Key: BaseImage)
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

      // إضافة الصور الإضافية المتعددة (Key: Images)
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

      // 🎯 طباعة آمنة للـ URL المكتمل لتسهيل تتبع أي تغيير مع الباك-إند
      print("🚀 Requesting Endpoint: ${EndPoints.getApartment}");
      print("🚀 Query Params Sent: $queryParams");

      // 3. إرسال الطلب النهائي للسيرفر
      final response = await _dio.post(
        EndPoints.postApartment, // 👈 إذا أكد لك الباك إند مساراً مختلفاً لـ POST، قم بتغيير السهم هنا فقط
        queryParameters: queryParams, 
        data: formData,               
      );

      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  /// 🛠️ دالة مساعدة محصنة ومعالجة لأخطاء الـ Dio لمنع الانهيار وخطأ الـ Index الشهير
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'انتهت مهلة الاتصال بالسيرفر، يرجى المحاولة لاحقاً.';
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة استقبال البيانات من السيرفر.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        String? serverMessage;

        // الحماية الذهبية: نتحقق أولاً هل الـ data عبارة عن Map قبل فحص الـ Keys
        if (error.response?.data is Map<String, dynamic> || error.response?.data is Map) {
          serverMessage = error.response?.data?['message'] ?? error.response?.data?['Message'];
        } 
        // إذا أرجع السيرفر قائمة أخطاء بدلاً من Map
        else if (error.response?.data is List) {
          final listData = error.response?.data as List;
          if (listData.isNotEmpty && listData.first is Map) {
            serverMessage = listData.first['message'] ?? listData.first['Message'];
          }
        }

        // إذا لم نجد أي رسالة مخصصة، نأخذ الـ statusMessage الافتراضي
        serverMessage ??= error.response?.statusMessage;

        return 'خطأ من السيرفر ($statusCode): ${serverMessage ?? "فشل الطلب (تأكد من الـ Endpoint)"}';
        
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.';
      default:
        return 'عذراً، حدث خطأ أثناء الاتصال بالشبكة.';
    }
  }
}