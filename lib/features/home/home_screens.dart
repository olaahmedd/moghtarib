import 'package:flutter/material.dart';
import 'package:moghtarib/features/home/semsar/view/semsar_home_view.dart';
import 'package:moghtarib/features/home/student/view/student_home_view.dart';
//import '../../core/utils/app_assets.dart';
//import '../../core/utils/app_colors.dart';
import 'presentation/views/base_home_screen.dart';
import 'admin/view/admin_home_view.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminHomeView();
  }
}

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    // return const BaseHomeScreen(
    //   drawerTitle: 'Student',
    //   body: _PlaceholderBody(title: 'Student Home'),
    // );
    return const StudentHomeView();
  }
}

class SemsarHome extends StatelessWidget {
  const SemsarHome({super.key});

  @override
  Widget build(BuildContext context) {
    // return const BaseHomeScreen(
    //   drawerTitle: 'Semsar',
    //   body: _PlaceholderBody(title: 'Semsar Home'),
    // );
    return const SemsarHomeView();
  }
}

class SanaieeHome extends StatelessWidget {
  const SanaieeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseHomeScreen(
      drawerTitle: 'Sanaiee',
      body: _PlaceholderBody(title: 'Sanaiee Home'),
    );
  }
}

class _PlaceholderBody extends StatelessWidget {
  final String title;
  const _PlaceholderBody({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }
}
