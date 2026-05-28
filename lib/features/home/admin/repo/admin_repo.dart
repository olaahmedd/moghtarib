import 'package:dartz/dartz.dart';

import '../../../../core/network/api_helper.dart';
import '../../../../core/network/end_points.dart';
import '../model/user_model.dart';
import'package:moghtarib/features/home/admin/model/sanaiee_model.dart';
import 'package:url_launcher/url_launcher.dart';
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
  //sanaiee
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
    // كود مخصص لتهيئة الرقم بالشكل الذي يقبله الواتساب الدولي (بدون + أو أصفار إضافية في البداية)
    // إذا كان الرقم مصرياً مثلاً يبدأ بـ 010، يجب أن يصبح 2010
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

  // 2️⃣ دالة حذف المستخدم (تم تقفيلها وحل مشكلة الـ Syntax والـ Return)
  

  // TODO: sanaiee + reports repo methods will be added later
}

  

