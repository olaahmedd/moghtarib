import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/admin/cubit/sanaiee_cubit/sanaiee_cubit.dart';
import 'package:moghtarib/core/utils/app_colors.dart';
import'package:moghtarib/features/home/presentation/views/base_home_screen.dart';
import 'package:moghtarib/features/home/admin/repo/admin_repo.dart';
// import 'package:moghtarib/features/home/admin/cubit/users_cubit/users_cubit.dart';
// import 'package:moghtarib/features/home/admin/view/users_tab_view.dart';
// import 'package:moghtarib/features/home/admin/view/reports_tab_view.dart';
 import 'package:moghtarib/features/home/admin/view/sanaiee_tab_view.dart';
import 'package:moghtarib/features/home/student/cubit/all_apartment/all_apartment_cubit.dart';
 import'package:moghtarib/features/home/student/repo/student_repo.dart';
 import'package:moghtarib/features/home/student/view/all_apartment_tab_view.dart';
class StudentHomeView extends StatelessWidget {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    
    final studentRepo = StudentRepo();
     final AdminRepo() = AdminRepo();


    return MultiBlocProvider(
      providers: [
        BlocProvider<AllApartmentCubit>(
          
          create: (_) => AllApartmentCubit(studentRepo)..fetchAllApartment, 
         ),
        BlocProvider<SanaieeCubit>(
         
          create: (_) => SanaieeCubit(AdminRepo())..fetchSanaiee(), 
        ),

        
      ],
      child: DefaultTabController(
        length: 2,
        child: BaseHomeScreen(
          drawerTitle: 'Student',
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
                    
                    Tab(text: 'Apartment'),
                    Tab(text: 'Sanaiee'),
                    //Tab(text: 'Favourite'),
                  
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                  ApartmentTabView(),
                    SanaieeTabView(), 
                  //FavouriteTabView(),
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