import 'package:flutter/widgets.dart';
import'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/core/cache/cache_keys.dart';
import 'package:moghtarib/core/helper/navigator.dart';
import 'package:moghtarib/core/helper/navigator.dart' as app_navigator;
import 'package:moghtarib/features/home/home_screens.dart';
import 'package:moghtarib/features/screen/welcome.dart';


// class RoleBasedNavigation {
//   static const Set<String> _supportedRoles = {
//     'admin',
//     'semsar',
//     'student',
//     'sanaiee',
//   };

//   static String? normalizeRole(String? role) {
//     final r = role?.trim().toLowerCase();
//     if (r == null || r.isEmpty) return null;
//     if (!_supportedRoles.contains(r)) return null;
//     return r;
//   }

//   static Future<void> saveRole(String role) async {
//     final normalized = normalizeRole(role);
//     if (normalized == null) return;
//     await CacheHelper.setValue(key: CacheKeys.userRole, value: normalized);
//   }

//   static Future<void> navigateByRole({
//     required String role,
//     bool replace = true,
//   }) async {
//     final normalized = normalizeRole(role);
//     if (normalized == null) {
//       app_navigator.Navigator.goTo(
//         screen: const WelcomeScreen(),
//         isReplace: replace,
//       );
//       return;
//     }

//     Widget screen;
//     switch (normalized) {
//       case 'admin':
//         screen = const AdminHome();
//         break;
//       case 'semsar':
//         screen = const SemsarHome();
//         break;
//       case 'student':
//         screen = const StudentHome();
//         break;
//       case 'sanaiee':
//         screen = const SanaieeHome();
//         break;
//       default:
//         screen = const WelcomeScreen();
//     }

//     await saveRole(normalized);

//     app_navigator.Navigator.goTo(
//       screen: screen,
//       isReplace: replace,
//     );
//   }
// }
import 'package:flutter/material.dart';
// تأكدي من استيراد الملفات الصحيحة لشاشات الـ Home عندك
// import 'path_to_admin_home.dart';
// import 'path_to_semsar_home.dart';
// import 'path_to_student_home.dart';
// import 'path_to_sanaiee_home.dart';
// import 'path_to_welcome_screen.dart';
// import 'path_to_cache_helper.dart';
// import 'path_to_app_navigator.dart' as app_navigator;

class RoleBasedNavigation {
  static const Set<String> _supportedRoles = {
    'admin',
    'semsar',
    'student',
    'sanaiee',
  };

  static String? normalizeRole(String? role) {
    final r = role?.trim().toLowerCase();
    if (r == null || r.isEmpty) return null;
    if (!_supportedRoles.contains(r)) return null;
    return r;
  }

  static Future<void> saveRole(String role) async {
    final normalized = normalizeRole(role);
    if (normalized == null) return;
    await CacheHelper.setValue(key: CacheKeys.userRole, value: normalized);
  }

  static Future<void> navigateByRole({
    required String role,
    bool replace = true,
  }) async {
    final normalized = normalizeRole(role);
    if (normalized == null) {
      app_navigator.Navigator.goTo(
        screen: const WelcomeScreen(),
        isReplace: replace,
      );
      return;
    }

    Widget screen;
    switch (normalized) {
      case 'admin':
        screen = const AdminHome();
        break;
      case 'semsar':
        screen = const SemsarHome();
        break;
      case 'student':
        screen = const StudentHome();
        break;
      case 'sanaiee':
        screen = const SanaieeHome(); // شاشة الصنايعي
        break;
      default:
        screen = const WelcomeScreen();
    }

    // 1️⃣ بنسيف الـ Role الجديد في الكاش وبنستنى لحد ما يخلص تماماً
    await saveRole(normalized);

    // 2️⃣ 🎯 السطر السحري: بنعمل تأخير بسيط جداً (50 مللي ثانية) 
    // عشان نضمن إن الـ Frame الحالي في فلاتر انتهى والذاكرة قرأت الـ Role الجديد
    await Future.delayed(const Duration(milliseconds: 50));

    // 3️⃣ التوجيه الفوري للشاشة المناسبة بدون شاشات فاضية
    app_navigator.Navigator.goTo(
      screen: screen,
      isReplace: replace,
    );
  }
}