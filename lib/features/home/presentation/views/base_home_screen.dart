import 'package:flutter/material.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
class BaseHomeScreen extends StatelessWidget {
  final String drawerTitle;
  final VoidCallback? onLogout;
  final Widget body;

  const BaseHomeScreen({
    super.key,
    required this.drawerTitle,
    this.onLogout,
    required this.body,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        centerTitle: true,
        title: Image.asset(
          AppAssets.logo,
          width: 38,
          height: 31,
          fit: BoxFit.scaleDown,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.scaffoldBackground,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: AppColors.scaffoldBackground),
                child: Center(
                  child: Image.asset(
                    AppAssets.logo,
                    width: 72,
                    height: 72,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const _AboutScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Placeholder: light/dark mode + language toggles.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const _EmptySettingsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Placeholder: change password feature.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const _EmptyProfileScreen(),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.white24),
              // ListTile(
              //   leading: const Icon(Icons.logout, color: Colors.white),
              //   title: const Text(
              //     'Logout',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     onLogout?.call();
              //   },
              // ),
              ListTile(
  leading: const Icon(Icons.logout, color: Colors.white),
  title: const Text(
    'Logout',
    style: TextStyle(color: Colors.white),
  ),
  onTap: () async {
    // 1. غلق القائمة الجانبية (Drawer)
    Navigator.of(context).pop();

    // 2. مسح بيانات الجلسة من الكاش (عشان لما يفتح تاني يروح للـ Splash ومنها للـ Welcome)
    // ملحوظة: تأكدي من عمل import لـ CacheHelper و CacheKeys في الملف ده لو مش معمولين.
    await CacheHelper.setValue(key: CacheKeys.accessToken, value: null); // أو قيمة فارغة ''
    await CacheHelper.setValue(key: CacheKeys.userRole, value: null);

    // 3. تشغيل الـ callback الإضافي لو مبعوت من بره
    onLogout?.call();

    // 4. توجيهه لصفحة الـ Welcome ومسح كل الصفحات القديمة من الـ Stack
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.welcome, // اسم الراوت الخاص بصفحة let's start / welcome عندك
        (route) => false,  // مسح كل الصفحات السابقة تماماً
      );
    }
  },
),
            ],
          ),
        ),
      ),
      body: body,

    );
  }
}

class _AboutScreen extends StatelessWidget {
  const _AboutScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        centerTitle: true,
        title: const Text('About', style: TextStyle(color: Colors.white)),
      ),
      body: const SizedBox.shrink(),
    );
  }
}

class _EmptySettingsScreen extends StatelessWidget {
  const _EmptySettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        centerTitle: true,
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
      ),
      body: const SizedBox.shrink(),
    );
  }
}

class _EmptyProfileScreen extends StatelessWidget {
  const _EmptyProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
