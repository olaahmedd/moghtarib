import 'package:dartz/dartz.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';
import '../model/All_apartment_model.dart';

class StudentRepo {
  
  
  Future<Either<String, List<AllApartmentModel>>> getAllApartments({String? searchText}) async {
    final hasSearch = searchText != null && searchText.trim().isNotEmpty;

    final result = await ApiHelper.get(
      endPoint: hasSearch ? EndPoints.searchApartment : EndPoints.getApartment,
      isProtected: false,
      queryParameters: hasSearch ? {'query': searchText.trim()} : null,
    );

    return result.map((responseBody) {
      
      if (responseBody is List) {
        return responseBody.map((e) => AllApartmentModel.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      
      
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