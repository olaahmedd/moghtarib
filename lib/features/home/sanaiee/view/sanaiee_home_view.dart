import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/sanaiee/view/add_department_tap_view.dart';
import '../../../../core/utils/app_colors.dart';
import '../../presentation/views/base_home_screen.dart';
import '../../admin/repo/admin_repo.dart';
import '../../student/repo/student_repo.dart';
import '../../student/cubit/my_report_cubit/my_report_cubit.dart';
import '../../student/view/add_report_tab_view.dart';
import '../../student/view/my_report_tab_view.dart';
import '../cubit/department_cubit/department_cubit.dart';
import '../repo/sanaiee_repo.dart';
class SanaieeHomeView extends StatelessWidget {
  const SanaieeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final studentRepo = StudentRepo();
    final adminRepo = AdminRepo();
    final sanaieeRepo =SanaieeRepo();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
      create: (context) => DepartmentCubit(sanaieeRepo), 
    ),
       
       BlocProvider(
        create: (context) => MyReportsCubit(studentRepo)..fetchMyReports(),
      
        )
      ],
      child: DefaultTabController(
        length: 3, 
        child: BaseHomeScreen(
          drawerTitle: 'Sanaiee',
          onLogout: null,
          body: Column(
            children: [
              Material(
                color: AppColors.scaffoldBackground,
                child: TabBar(
                  isScrollable: true, 
                  tabAlignment: TabAlignment.start,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                 
                  labelStyle: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  tabs: const [
                  
                    Tab(text: 'Add Department'),
                    Tab(text: 'Add Report'),
                    Tab(text: 'My Report'),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                  
                    AddDepartmentTabView(),
                    AddReportTabView(),
                    MyReportTabView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}