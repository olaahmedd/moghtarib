import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/admin/cubit/reports_cubit/reports_cubit.dart';
import 'package:moghtarib/features/home/admin/cubit/sanaiee_cubit/sanaiee_cubit.dart';
import 'package:moghtarib/core/utils/app_colors.dart';
import'package:moghtarib/features/home/presentation/views/base_home_screen.dart';
import 'package:moghtarib/features/home/admin/repo/admin_repo.dart';
import 'package:moghtarib/features/home/admin/cubit/users_cubit/users_cubit.dart';
import 'package:moghtarib/features/home/admin/view/users_tab_view.dart';
import 'package:moghtarib/features/home/admin/view/reports_tab_view.dart';
import 'package:moghtarib/features/home/admin/view/sanaiee_tab_view.dart';
import 'package:moghtarib/features/home/sanaiee/view/add_department_tap_view.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
   
    final adminRepo = AdminRepo();

    return MultiBlocProvider(
      providers: [
        BlocProvider<UsersCubit>(
          create: (_) => UsersCubit(adminRepo),
        ),
        BlocProvider<SanaieeCubit>(
       
          create: (_) => SanaieeCubit(adminRepo)..fetchSanaiee(), 
        ),
        BlocProvider<ReportCubit>(create: (_) => ReportCubit(adminRepo)..fetchReports()),
      ],
      child: DefaultTabController(
        length: 4,
        child: BaseHomeScreen(
          drawerTitle: 'Admin',
          onLogout: null,
          body: Column(
            children: [
              Material(
                color: AppColors.scaffoldBackground,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha:0.7),
                  indicatorColor: Colors.white,
                  tabs: const [
                    Tab(text: 'Users'),
                    Tab(text: 'Sanaiee'),
                    Tab(text: 'Reports'),
                    Tab(text: 'Add department'),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    UsersTabView(),
                    SanaieeTabView(), 
                    ReportsTabView(),
                    AddDepartmentTabView(),
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