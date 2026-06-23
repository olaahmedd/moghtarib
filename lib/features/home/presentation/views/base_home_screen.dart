import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/presentation/about/about_screen.dart';
import 'package:moghtarib/features/home/presentation/settings/change_password_cubit/change_password_cubit.dart';
import 'package:moghtarib/features/home/presentation/settings/change_password_repo/change_password_repo.dart';
import 'package:moghtarib/features/home/presentation/settings/change_password_view/change_password_view.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/routes/app_routes.dart';


// class BaseHomeScreen extends StatelessWidget {
//   final String drawerTitle;
//   final VoidCallback? onLogout;
//   final Widget body;

//   const BaseHomeScreen({
//     super.key,
//     required this.drawerTitle,
//     this.onLogout,
//     required this.body,
//   });


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackground,
//       appBar: AppBar(
//         backgroundColor: AppColors.scaffoldBackground,
//         centerTitle: true,
//         title: Image.asset(
//           AppAssets.logo,
//           width: 88,
//           height: 81,
//           fit: BoxFit.scaleDown,
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       drawer: Drawer(
//         backgroundColor: AppColors.scaffoldBackground,
//         child: SafeArea(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(color: AppColors.scaffoldBackground),
//                 child: Center(
//                   child: Image.asset(
//                     AppAssets.logo,
//                     width: 92,
//                     height: 92,
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.home, color: Colors.white),
//                 title: const Text(
//                   'Home',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.info_outline, color: Colors.white),
//                 title: const Text(
//                   'About',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => AboutScreen(),
//                     ),
//                   );
//                 },
//               ),
//              // 1. زرار الإعدادات (Settings) - بيفتح صفحة الإعدادات
//               ListTile(
//                 leading: const Icon(Icons.settings, color: Colors.white),
//                 title: const Text(
//                   'Settings',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => const ChangePasswordScreen(), // الشاشة الصح للإعدادات
//                     ),
//                   );
//                 },
//               ),

//               // 2. زرار البروفايل (Profile) - بيفتح البروفايل ومعه الـ Cubit الخاص به
//               ListTile(
//                 leading: const Icon(Icons.person, color: Colors.white),
//                 title: const Text(
//                   'Profile',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => BlocProvider(
//                         create: (context) => UserCubit(UserRepo()), // بننشئ الـ Cubit هنا
//                         child: const _EmptyProfileScreen(), // الشاشة اللي ظاهرة في الموبايل عندك وبتقرأ الـ Cubit
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const Divider(color: Colors.white24),
//               // ListTile(
//               //   leading: const Icon(Icons.logout, color: Colors.white),
//               //   title: const Text(
//               //     'Logout',
//               //     style: TextStyle(color: Colors.white),
//               //   ),
//               //   onTap: () {
//               //     Navigator.of(context).pop();
//               //     onLogout?.call();
//               //   },
//               // ),
//               ListTile(
//   leading: const Icon(Icons.logout, color: Colors.white),
//   title: const Text(
//     'Logout',
//     style: TextStyle(color: Colors.white),
//   ),
//   onTap: () async {
    
//     Navigator.of(context).pop();

    
//     await CacheHelper.setValue(key: CacheKeys.accessToken, value: null); 
//     await CacheHelper.setValue(key: CacheKeys.userRole, value: null);

   
//     onLogout?.call();

    
//     if (context.mounted) {
//       Navigator.pushNamedAndRemoveUntil(
//         context,
//         AppRoutes.welcome,
//         (route) => false, 
//       );
//     }
//   },
// ),
//             ],
//           ),
//         ),
//       ),
//       body: body,

//     );
//   }
// }

// class _AboutScreen extends StatelessWidget {
//   const _AboutScreen();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackground,
//       appBar: AppBar(
//         backgroundColor: AppColors.scaffoldBackground,
//         centerTitle: true,
//         title: const Text('About', style: TextStyle(color: Colors.white)),
//       ),
//       body: const SizedBox.shrink(),
//     );
//   }
// }

// class _EmptySettingsScreen extends StatelessWidget {
//   const _EmptySettingsScreen();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackground,
//       appBar: AppBar(
//         backgroundColor: AppColors.scaffoldBackground,
//         centerTitle: true,
//         title: const Text('Settings', style: TextStyle(color: Colors.white)),
//       ),
//       body: const SizedBox.shrink(),
//     );
//   }
// }

// class _EmptyProfileScreen extends StatelessWidget {
//   const _EmptyProfileScreen();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackground,
//       appBar: AppBar(
//         backgroundColor: AppColors.scaffoldBackground,
//         centerTitle: true,
//         title: const Text('Profile', style: TextStyle(color: Colors.white)),
//       ),
//       body: const SizedBox.shrink(),
//     );
//   }
// }

// ملاحظة: تأكدي من أن مسارات الـ Imports لملفات الـ Cubit والـ Repo والـ الألوان صحيحة لديكِ.

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
          width: 88,
          height: 81,
          fit: BoxFit.scaleDown,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // الحل السحري: تغليف الـ Drawer بالـ BlocProvider ليكون متاحاً لجميع الشاشات الفرعية
      drawer: BlocProvider(
        create: (context) => UserCubit(UserRepo()),
        child: Drawer(
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
                      width: 92,
                      height: 92,
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
                        builder: (_) => AboutScreen(),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
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
                    // بما أن الـ Drawer مغلف بالـ Cubit، فالشاشة المفتوحة هنا ستجده في الـ Context تلقائياً
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const _EmptyProfileScreen(), 
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();

                    await CacheHelper.setValue(key: CacheKeys.accessToken, value: null);
                    await CacheHelper.setValue(key: CacheKeys.userRole, value: null);

                    onLogout?.call();

                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.welcome,
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
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