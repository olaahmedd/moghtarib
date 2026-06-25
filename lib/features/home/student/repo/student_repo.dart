import 'package:dartz/dartz.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';
import '../model/All_apartment_model.dart';
import '../model/add_report_model.dart';
import '../../../../core/cache/cache_helper.dart';
import '../model/my_report_model.dart';
class StudentRepo {
  
  Future<Either<String, List<AllApartmentModel>>> getAllApartments({String? searchText}) async {
    final hasSearch = searchText != null && searchText.trim().isNotEmpty;

    final result = await ApiHelper.get(
      endPoint: hasSearch ? EndPoints.searchapartment : EndPoints.getApartment,
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
  }


Future<Either<String, bool>> addReport({required AddReportModel report}) async {
  final String studentId = CacheHelper.getValue('userId')?.toString() ?? "";
  
  
  final String url = '${EndPoints.addReport}?reportText=${report.text}';


  final result = await ApiHelper.post(
    endPoint: url,
    data: {}, 
    isProtected: true,
  );

  return result.map((response) => true);
}


Future<Either<String, List<ReportModel>>> getMyReports() async {
  final result = await ApiHelper.get(
    endPoint: EndPoints.getMyReports, 
    isProtected: true,
  );

  return result.map((responseBody) {
    if (responseBody is List) {
      return responseBody.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return <ReportModel>[];
  });
}
}