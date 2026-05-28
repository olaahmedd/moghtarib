import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moghtarib/core/utils/app_colors.dart';
import'package:moghtarib/features/home/presentation/views/base_home_screen.dart';
import 'package:moghtarib/features/home/admin/repo/admin_repo.dart';
import 'package:moghtarib/features/home/admin/cubit/users_cubit/users_cubit.dart';
import 'package:moghtarib/features/home/admin/view/users_tab_view.dart';
import 'package:moghtarib/features/home/admin/view/reports_tab_view.dart';
import 'package:moghtarib/features/home/admin/view/sanaiee_tab_view.dart';
class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ✨ تم تعديل هذا السطر لإرسال الـ repo كـ positional parameter مباشرة
      create: (_) => UsersCubit(AdminRepo()), 
      child: DefaultTabController(
        length: 3,
        child: BaseHomeScreen(
          drawerTitle: 'Admin',
          onLogout: null,
          body: Column(
            children: [
              Material(
                color: AppColors.scaffoldBackground,
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha:0.7),
                  indicatorColor: Colors.white,
                  tabs: const [
                    Tab(text: 'Users'),
                    Tab(text: 'Sanaiee'),
                    Tab(text: 'Reports'),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    UsersTabView(),
                    SanaieeTabView(),
                    ReportsTabView(),
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