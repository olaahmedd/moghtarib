import 'package:dartz/dartz.dart';

import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';
import '../model/user_model.dart';


// class AdminRepo {
//   Future<Either<String, List<UserModel>>> getAllUsers({String? searchText}) async {
//     final hasSearch = searchText != null && searchText.trim().isNotEmpty;

//     // ✨ الـ ApiHelper.get الآن مرن ويعيد الـ data مباشرة بدون كاستينج إجباري لـ Map
//     final result = await ApiHelper.get(
//       endPoint: hasSearch ? EndPoints.searchByName : EndPoints.getAllUsers,
//       isProtected: false,
//       queryParameters: hasSearch ? {'name': searchText.trim()} : null,
//     );

//     // ✨ قمنا بتغيير اسم المتغير من (map) إلى (responseBody) لأنه قد يكون List أو Map
//     return result.map((responseBody) {
      
//       // 1️⃣ الحالة الأولى: إذا كان السيرفر يعيد قائمة مستخدمين مباشرة [ {...}, {...} ]
//       if (responseBody is List) {
//         return responseBody.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
//       }
      
//       // 2️⃣ الحالة الثانية: إذا كانت البيانات مغلفة داخل كائن يحمل مفتاحاً مثل { "data": [...] }
//       if (responseBody is Map<String, dynamic>) {
//         final dynamic data = responseBody['data'] ?? responseBody['result'] ?? responseBody['users'] ?? responseBody;
        
//         if (data is List) {
//           return data.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
//         }
        
//         if (data is Map<String, dynamic>) {
//           final dynamic list = data['data'] ?? data['result'];
//           if (list is List) {
//             return list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
//           }
//         }
//       }
      
//       return <UserModel>[]; // قائمة فارغة احتياطية في حال لم نجد بيانات بالصيغ المتوقعة
//     });
//   }
// // 📢 قومي بتغيير int إلى String هنا:
// Future<Either<String, bool>> deleteUser({required String userId}) async {
//   // ✨ دمج علامة الاستفهام والـ Id مباشرة في الـ String ليتوافق مع الـ ApiHelper والـ Swagger
//   final result = await ApiHelper.delete(
//     endPoint: '${EndPoints.deleteUser}?id=$userId',
//     isProtected: false,
//   );

//   return result.map((responseBody) {
//     if (responseBody is Map<String, dynamic>) {
//       final dynamic successRaw = responseBody['success'] ?? responseBody['Success'];
//       if (successRaw is bool) return successRaw;
//     }
//     return true; 
//   });


// }
//   // TODO: sanaiee + reports repo methods will be added later
// }


class AdminRepo {
  
  // 1️⃣ دالة جلب جميع المستخدمين (شغالة وسليمة تماماً)
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

  // 2️⃣ دالة حذف المستخدم (تم تقفيلها وحل مشكلة الـ Syntax والـ Return)
  Future<Either<String, bool>> deleteUser({required String userId}) async {
    // رجعناها لـ delete الصحيحة مع الـ Id الكابيتال المتوافق مع الـ Swagger
    final result = await ApiHelper.delete(
      endPoint: '${EndPoints.deleteUser}?Id=$userId',
      isProtected: false,
    );

    return result.map((responseBody) {
      if (responseBody is Map<String, dynamic>) {
        final dynamic successRaw = responseBody['success'] ?? responseBody['Success'];
        if (successRaw is bool) return successRaw;
      }
      return true; // إرجاع افتراضي في حال نجاح الطلب ولم يحتوي الـ Body على كائن معقد
    });
  }

  // TODO: sanaiee + reports repo methods will be added later
}
