import 'dart:io';
import 'package:dio/dio.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/core/network/end_points.dart';
import '../model/add_apartment_model.dart';
import 'package:moghtarib/core/cache/cache_keys.dart';

class ApartmentRepo {
  final Dio _dio;

  ApartmentRepo({Dio? dio}) : _dio = dio ?? Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl, 
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

 
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