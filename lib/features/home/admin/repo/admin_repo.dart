import 'package:dartz/dartz.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/features/home/admin/model/report_model.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';
import '../model/user_model.dart';
import'package:moghtarib/features/home/admin/model/sanaiee_model.dart';
import 'package:url_launcher/url_launcher.dart';
class AdminRepo {
  Future<Either<String, List<UserModel>>> getAllUsers({String? searchText}) async {
    final hasSearch = searchText != null && searchText.trim().isNotEmpty;

    final result = await ApiHelper.get(
      endPoint: hasSearch ? EndPoints.searchByName : EndPoints.getAllUsers,
      isProtected: false,
      queryParameters: hasSearch ? {'name': searchText.trim()} : null,
    );

    return result.map((responseBody) {
      if (responseBody is List) {
        return responseBody.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      
      if (responseBody is Map<String, dynamic>) {
        final dynamic data = responseBody['data'] ?? responseBody['result'] ?? responseBody['users'] ?? responseBody;
        
        if (data is List) {
          return data.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
        }
        
        if (data is Map<String, dynamic>) {
          final dynamic list = data['data'] ?? data['result'];
          if (list is List) {
            return list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
          }
        }
      }
      
      return <UserModel>[]; 
    });
  }

Future<Either<String, bool>> deleteUser({required String userId}) async {
  final result = await ApiHelper.delete(
    endPoint: '${EndPoints.deleteUser}?id=$userId', 
    isProtected: true,
  );

  return result.map((responseBody) => true);
}
  
 Future<Either<String, List<SanaieeModel>>> getAllSanaieeia({String? searchText}) async {
    final hasSearch = searchText != null && searchText.trim().isNotEmpty;

    final result = await ApiHelper.get(
      endPoint: hasSearch ? EndPoints.searchByName : EndPoints.getAllSanaieeia,
      isProtected: false,
      queryParameters: hasSearch ? {'name': searchText.trim()} : null,
    );

    return result.map((responseBody) {
      if (responseBody is List) {
        return responseBody.map((e) => SanaieeModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      
      if (responseBody is Map<String, dynamic>) {
        final dynamic data = responseBody['data'] ?? responseBody['result'] ?? responseBody['users'] ?? responseBody;
        
        if (data is List) {
          return data.map((e) => SanaieeModel.fromJson(e as Map<String, dynamic>)).toList();
        }
        
        if (data is Map<String, dynamic>) {
          final dynamic list = data['data'] ?? data['result'];
          if (list is List) {
            return list.map((e) => SanaieeModel.fromJson(e as Map<String, dynamic>)).toList();
          }
        }
      }
      
      return <SanaieeModel>[]; 
    });
  }
  Future<void> openWhatsApp(String phoneNumber) async {
    
    String formattedPhone = phoneNumber;
    if (phoneNumber.startsWith('0')) {
      formattedPhone = '20${phoneNumber.substring(1)}';
    }

    final Uri whatsappUri = Uri.parse("https://wa.me/$formattedPhone");

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      throw 'حدث خطأ أثناء محاولة فتح واتساب: $e';
    }
  }

Future<Either<String, bool>> deleteReport(String reportId) async {

  final result = await ApiHelper.delete(
    endPoint: '${EndPoints.deleteReport}?reportId=$reportId', 
    isProtected: true,
  );

  return result.map((responseBody) {
    return true; 
  });
}
Future<Either<String, List<ReportModel>>> getAllReports() async {
  

final String adminId = CacheHelper.getValue('userId')?.toString() ?? "";

  final result = await ApiHelper.get(
    endPoint: EndPoints.getAllReports,
    isProtected: true,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },

    queryParameters: {
      'userId': adminId ?? "", 
    },
  );

  return result.map((responseBody) {
 
    if (responseBody is List) {
      return responseBody.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    
    
    if (responseBody is Map<String, dynamic>) {
        final dynamic data = responseBody['data'] ?? responseBody['result'] ?? responseBody;
        if (data is List) {
        return data.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();
        }
    }
    
    return <ReportModel>[];
  });
}
}