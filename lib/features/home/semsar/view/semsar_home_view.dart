import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/semsar/cubit/semsar/add_apartment_cubit.dart';
import '../../../../core/utils/app_colors.dart';
import '../../presentation/views/base_home_screen.dart';
//import '../repo/add_apartment_repo.dart' hide ApartmentRepo;
import 'package:moghtarib/features/home/semsar/view/add_apartment_tap_view.dart';
import 'package:moghtarib/features/home/semsar/repo/add_apartment_repo.dart';

class SemsarHomeView extends StatelessWidget {
  const SemsarHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    
    final semsarRepo = ApartmentRepo();

    return BlocProvider<ApartmentCubit>(
      create: (_) => ApartmentCubit(semsarRepo),
      child: DefaultTabController(
        length: 1,
        child: BaseHomeScreen(
          drawerTitle: 'Semsar',
          onLogout: null,
          body: Column(
            children: [
              Material(
                color: AppColors.scaffoldBackground,
                child: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Color(0xFF6F32E4),
                  tabs: [
                    Tab(text: 'Add Apartment'), 
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    AddApartmentTabView(), 
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