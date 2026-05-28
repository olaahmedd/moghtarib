import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:moghtarib/features/screen/welcome.dart';
// import '../../core/utils/app_assets.dart';
import '../../core/utils/app_colors.dart';
import '../../core/cache/cache_helper.dart';
import '../../core/cache/cache_keys.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/jwt_role_parser.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      final token = CacheHelper.getValue(CacheKeys.accessToken) as String?;
      if (token == null || token.isEmpty) {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
        return;
      }

      // Prefer saved role first (fast + avoids API call).
      final savedRole = CacheHelper.getValue(CacheKeys.userRole) as String?;
      if (savedRole != null && savedRole.isNotEmpty) {
        final role = savedRole.toLowerCase();
        switch (role) {
          case 'admin':
            Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
            return;
          case 'student':
            Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
            return;
          case 'semsar':
            Navigator.pushReplacementNamed(context, AppRoutes.semsarHome);
            return;
          case 'sanaiee':
            Navigator.pushReplacementNamed(context, AppRoutes.sanaieeHome);
            return;
          default:
            Navigator.pushReplacementNamed(context, AppRoutes.welcome);
            return;
        }
      }

      // Fallback: decode role from the stored JWT token.
      // (Avoid calling /UserRoles to prevent backend 400 errors.)
      final role = JwtRoleParser.extractRole(token);
      if (role == null || role.isEmpty) {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
        return;
      }

      final normalized = role.toLowerCase();
      await CacheHelper.setValue(key: CacheKeys.userRole, value: normalized);

      switch (normalized) {
        case 'admin':
          Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
          break;
        case 'student':
          Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
          break;
        case 'semsar':
          Navigator.pushReplacementNamed(context, AppRoutes.semsarHome);
          break;
        case 'sanaiee':
          Navigator.pushReplacementNamed(context, AppRoutes.sanaieeHome);
          break;
        default:
          Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Image.asset(
          'assets/images/Logo.png',
          width: 500.w,
          height: 450.h,
        ),
      ),
    );
  }
}