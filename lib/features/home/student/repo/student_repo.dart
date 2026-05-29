import 'package:dartz/dartz.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';
import '../model/All_apartment_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../admin/model/sanaiee_model.dart';
class StudentRepo {
  
  // 1️⃣ جلب جميع الشقق المتاحة للطلاب
  Future<Either<String, List<AllApartmentModel>>> getAllApartments({String? searchText}) async {
    final hasSearch = searchText != null && searchText.trim().isNotEmpty;

    final result = await ApiHelper.get(
      endPoint: hasSearch ? EndPoints.searchApartment : EndPoints.getApartment,
      isProtected: false,
      queryParameters: hasSearch ? {'query': searchText.trim()} : null,
    );

    return result.map((responseBody) {
      // إذا كان الرد عبارة عن List مباشرة
      if (responseBody is List) {
        return responseBody.map((e) => AllApartmentModel.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      
      // إذا كان الرد Map ويحتوي على الكائنات بداخل كباري معينة
      if (responseBody is Map) {
        final dynamic data = responseBody['data'] ?? responseBody['result'] ?? responseBody['apartments'] ?? responseBody;
        
        if (data is List) {
          return data.map((e) => AllApartmentModel.fromJson(Map<String, dynamic>.from(e))).toList();
        }
        
        if (data is Map) {
          final dynamic list = data['data'] ?? data['result'];
          if (list is List) {
            return list.map((e) => AllApartmentModel.fromJson(Map<String, dynamic>.from(e))).toList();
          }
        }
      }
      
      return <AllApartmentModel>[]; 
    });
  }}