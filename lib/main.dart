import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/features/auth/views/register_view.dart';
import 'package:moghtarib/features/auth/views/login_view.dart';
import 'package:moghtarib/features/screen/splash.dart';
import 'package:moghtarib/features/screen/welcome.dart';
import 'package:moghtarib/features/home/home_screens.dart';
import 'package:moghtarib/core/routes/app_routes.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
  return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true, 
      builder: (context, child) {
     
          return GetMaterialApp(
          title: 'Moghtarib',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.welcome: (context) => const WelcomeScreen(),
            AppRoutes.register: (context) => RegisterView(),
            AppRoutes.login: (context) => const LoginView(),
            AppRoutes.adminHome: (context) => const AdminHome(),
            AppRoutes.studentHome: (context) => const StudentHome(),
            AppRoutes.semsarHome: (context) => const SemsarHome(),
            AppRoutes.sanaieeHome: (context) => const SanaieeHome(),
          },

        );
      },
  );
  }
}