import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/semantics.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/core/network/end_points.dart';
import '../model/add_apartment_model.dart';
import 'package:moghtarib/core/cache/cache_keys.dart';
import 'package:path_provider/path_provider.dart'; 

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
//       // 1️⃣ حياكة الـ Query Parameters للنصوص والأرقام كما طلبها السيرفر في الـ Swagger
//       final Map<String, dynamic> queryParams = {
//         'City': apartment.city,
//         'Village': apartment.village,
//         'Location': apartment.location,
//         'Price': apartment.price.toInt(),          
//         'NumOfRooms': apartment.numOfRooms,  
//         'Type': apartment.type,              
//         'address_Lat': apartment.addressLat, 
//         'address_Lon': apartment.addressLon, 
//         'IsRent': apartment.isRent,          
//       };

//       // 2️⃣ الـ FormData مخصص للصور فقط
//       final FormData formData = FormData();

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

//       // 3️⃣ جلب التوكن بشكل آمن تماماً وتفادي خطأ الـ Object Casting
//       // final dynamic rawToken = CacheHelper.getValue('token');
//       // final String token = rawToken != null ? rawToken.toString() : '';

//       // print("🚀 SENDING TO: ${EndPoints.baseUrl}${EndPoints.postApartment}");
//       // print("🚀 AUTH TOKEN LENGTH: ${token.length}");
//   final String? token = CacheHelper.getValue(CacheKeys.accessToken)?.toString();

// print("🚀 التوكن المسترجع من الكاش: $token");

// if (token == null || token.isEmpty) {
//   // هنا يمكنك إضافة منطق لإجبار المستخدم على تسجيل الدخول مجدداً
//   print("🚨 تحذير: التوكن فارغ أو غير موجود!");
// }
//       // 4️⃣ إرسال الطلب النهائي المدمج بالسيرفر أونلاين
//       final response = await _dio.post(
//         EndPoints.postApartment, 
//         queryParameters: queryParams, // الحقول النصية في الـ URL
//         data: formData,               // الصور في الـ Body
//         options: Options(
//           contentType: 'multipart/form-data',
//           headers: {
//             if (token!.isNotEmpty) 'Authorization': 'Bearer $token',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//       return response;
//     } on DioException catch (e) {
//       print("🚨 FULL SERVER ERROR: ${e.response?.data}");
//       print("🚨 STATUS CODE: ${e.response?.statusCode}");
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

//         return 'خطأ من السيرفر ($statusCode): ${serverMessage ?? "فشل الطلب (تأكد من الـ Endpoint أو الـ Authorization)"}';
        
//       case DioExceptionType.connectionError:
//         return 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.';
//       default:
//         return 'عذراً، حدث خطأ أثناء الاتصال بالشبكة.';
//     }
//   }
//   // 1. دالة جلب شقق المستخدم الحالي
//   Future<Response> getMyApartments() async {
//     try {
//       final dynamic rawToken = CacheHelper.getValue('token');
//       final String token = rawToken != null ? rawToken.toString() : '';

//       final response = await _dio.get(
//         EndPoints.getApartmentForSignUser,
//         options: Options(
//           headers: {
//             if (token.isNotEmpty) 'Authorization': 'Bearer $token',
//             'Accept': 'application/json',
//           },
//         ),
//       );
//       return response;
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }

//   // 2. دالة حذف شقة معينة باستخدام الـ ID بتاعها
//   Future<Response> deleteApartment(int apartmentId) async {
//     try {
//       final dynamic rawToken = CacheHelper.getValue('token');
//       final String token = rawToken != null ? rawToken.toString() : '';

//       final response = await _dio.delete(
//         EndPoints.deleteApartment,
//         queryParameters: {
//           'id': apartmentId, // السيرفر غالباً بيتوقع الـ id كـ Query Parameter
//         },
//         options: Options(
//           headers: {
//             if (token.isNotEmpty) 'Authorization': 'Bearer $token',
//             'Accept': 'application/json',
//           },
//         ),
//       );
//       return response;
//     } on DioException catch (e) {
//       throw _handleDioError(e);
//     }
//   }
//   Future<void> updateApartment({
//   required int id,
//   required String city,
//   required String village,
//   required String location,
//   required int price,
//   required int numOfRooms,
//   required bool isRent,
//   required String baseImageURL,
// }) async {
//   try {
//     // السيرفر طالب الـ PUT على نفس الرابط /api/Apartment
//     final response = await _dio.put(
//       EndPoints.putApartment,
//       data: {
//         "id": id,
//         "city": city,
//         "village": village,
//         "location": location,
//         "address_Lat": 0, // قيم افتراضية زي ما الـ Swagger كاتب
//         "address_Lon": 0,
//         "price": price,
//         "numOfRooms": numOfRooms,
//         "baseImageURL": baseImageURL,
//         "type": 1,
//         "distanceByMeters": 0,
//         "isRent": isRent,
//       },
//     );
//     print("🔄 Update Status Code: ${response.statusCode}");
//   } catch (e) {
//     print("🚨 Repo Update Error: $e");
//     rethrow;
//   }
// }
// }

















class ApartmentRepo {
  final Dio _dio;

  ApartmentRepo({Dio? dio}) : _dio = dio ?? Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl, 
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // 1️⃣ دالة إضافة شقة جديدة
  Future<Response> addApartment({
    required AddApartmentModel apartment,
    File? baseImage,
    List<File>? additionalImages,
  }) async {
    try {
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

      final String? token = CacheHelper.getValue(CacheKeys.accessToken)?.toString();

      final response = await _dio.post(
        EndPoints.postApartment, 
        queryParameters: queryParams, 
        data: formData,              
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع: $e');
    }
  }

  // 2️⃣ دالة جلب شقق المستخدم الحالي
  Future<Response> getMyApartments() async {
    try {
      final String? token = CacheHelper.getValue(CacheKeys.accessToken)?.toString();

      final response = await _dio.get(
        EndPoints.getApartmentForSignUser,
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 3️⃣ دالة حذف شقة معينة باستخدام الـ ID
  Future<Response> deleteApartment(int apartmentId) async {
    try {
      final String? token = CacheHelper.getValue(CacheKeys.accessToken)?.toString();

      final response = await _dio.delete(
        EndPoints.deleteApartment,
        queryParameters: {
          'id': apartmentId, 
        },
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 4️⃣ دالة الـ Update الذكية والمقاومة لعيوب الـ Backend دايماً
  Future<Response> updateApartment({
    required AddApartmentModel apartment,
    File? baseImage,
  }) async {
    try {
      // إذا كان هناك صورة جديدة تم اختيارها من الجهاز، نرفع التعديل مباشرة
      if (baseImage != null && !baseImage.path.startsWith('http') && baseImage.existsSync()) {
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

        final FormData formData = FormData();
        formData.files.add(
          MapEntry(
            'BaseImage', 
            await MultipartFile.fromFile(
              baseImage.path,
              filename: baseImage.path.split('/').last,
            ),
          ),
        );

        final String? token = CacheHelper.getValue(CacheKeys.accessToken)?.toString();

        // نرفع البيانات الجديدة
        final response = await _dio.post(
          EndPoints.postApartment, 
          queryParameters: queryParams,
          data: formData, 
          options: Options(
            contentType: 'multipart/form-data',
            headers: {
              if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );

        // نجحت الإضافة بالصورة الجديدة؟ نحذف الكارت القديم فوراً لتجنب التكرار
        if (response.statusCode == 200 || response.statusCode == 201) {
          await deleteApartment(apartment.id!);
        }

        return response;
      } else {
        // 🎯 لو المستخدم مغيرش الصورة، وهو ده المطب الأساسي اللي بيعمل خطأ 400:
        // السيرفر بيرفض الـ Request لأن معندوش صورة جديدة. الحل؟ 
        // بنبعت البيانات الجديدة كشقة معدلة، وبمجرد نجاحها بنمسح القديمة تلقائياً من الـ Database
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

        final FormData formData = FormData();
        
        // طالما السيرفر إجباري بيحتاج الـ BaseImage، بننزله من الـ URL القديم المخزن في الـ Model ونعيده له كملف
        if (apartment.baseImageURL != null && apartment.baseImageURL!.isNotEmpty) {
          try {
            final Dio downloadDio = Dio();
            final String tempPath = '${Directory.systemTemp.path}/temp_old_image.jpg';
            await downloadDio.download(apartment.baseImageURL!, tempPath);
            
            formData.files.add(
              MapEntry(
                'BaseImage',
                await MultipartFile.fromFile(tempPath, filename: 'temp_old_image.jpg'),
              ),
            );
          } catch (_) {
            // لو فشل التحميل لأي سبب، نمنع الـ 400 تماماً بإننا نرمي Exception واضح للمستخدم
            throw Exception('برجاء اختيار صورة للشقة لإتمام عملية التعديل بنجاح.');
          }
        }

        final String? token = CacheHelper.getValue(CacheKeys.accessToken)?.toString();

        final response = await _dio.post(
          EndPoints.postApartment, 
          queryParameters: queryParams,
          data: formData, 
          options: Options(
            contentType: 'multipart/form-data',
            headers: {
              if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );

        // بعد ما الشقة الجديدة تنزل بالبيانات المعدلة، بنطير الشقة القديمة بالـ ID بتاعها
        if (response.statusCode == 200 || response.statusCode == 201) {
          await deleteApartment(apartment.id!);
        }

        return response;
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Failed to update apartment: ${e.toString()}');
    }
  }

  // 5️⃣ دالة معالجة أخطاء الـ Dio
  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      return Exception('خطأ من السيرفر (${e.response?.statusCode}): ${e.response?.data}');
    }
    return Exception('خطأ في الاتصال بالشبكة: ${e.message}');
  }
}