import 'package:flutter/widgets.dart';

import '../cache/cache_helper.dart';
import '../cache/cache_keys.dart';
import '../helper/navigator.dart' as app_navigator;
import '../../features/home/home_screens.dart';
import '../../features/screen/welcome.dart';


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
      case 'Student':
        screen = const StudentHome();
        break;
      case 'sanaiee':
        screen = const SanaieeHome();
        break;
      default:
        screen = const WelcomeScreen();
    }

    await saveRole(normalized);

    app_navigator.Navigator.goTo(
      screen: screen,
      isReplace: replace,
    );
  }
}
