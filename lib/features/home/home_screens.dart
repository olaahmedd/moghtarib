import 'package:flutter/material.dart';

import '../../core/utils/app_assets.dart';
import '../../core/utils/app_colors.dart';
//import '../../core/widgets/custom_appbar.dart';

class BaseHomeScreen extends StatelessWidget {
  final String title;
  const BaseHomeScreen({super.key, required this.title});

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
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EmptyRoleBody(roleTitle: 'Admin Home');
  }
}

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EmptyRoleBody(roleTitle: 'Student Home');
  }
}

class SemsarHome extends StatelessWidget {
  const SemsarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EmptyRoleBody(roleTitle: 'Semsar Home');
  }
}

class SanaieeHome extends StatelessWidget {
  const SanaieeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EmptyRoleBody(roleTitle: 'Sanaiee Home');
  }
}

class _EmptyRoleBody extends StatelessWidget {
  final String roleTitle;
  const _EmptyRoleBody({required this.roleTitle});

  @override
  Widget build(BuildContext context) {
    // Keep AppBar + Drawer + scaffold background constant.
    // Only the body is intentionally empty for now (per request).
    return BaseHomeScreen(
      title: roleTitle,
    );
  }
}

