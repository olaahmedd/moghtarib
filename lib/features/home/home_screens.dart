import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/sanaiee/view/sanaiee_home_view.dart';
import 'package:moghtarib/features/home/semsar/view/semsar_home_view.dart';
import 'package:moghtarib/features/home/student/cubit/add_report_cubit/add_report_cubit.dart';
import 'package:moghtarib/features/home/student/repo/student_repo.dart';
import 'package:moghtarib/features/home/student/view/student_home_view.dart';
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
   
    return BlocProvider(
    create: (context) => AddReportCubit(StudentRepo()), 
    child: const StudentHomeView(), 
  );
  }
}

class SemsarHome extends StatelessWidget {
  const SemsarHome({super.key});

  @override
  Widget build(BuildContext context) {

     return const SemsarHomeView();
  }
}

class SanaieeHome extends StatelessWidget {
  const SanaieeHome({super.key});

  @override
  Widget build(BuildContext context) {
   
       return BlocProvider(
    create: (context) => AddReportCubit(StudentRepo()), 
    child: const  SanaieeHomeView(), 
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