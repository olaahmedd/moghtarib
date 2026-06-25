import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
//import 'package:moghtarib/core/cache/cache_keys.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moghtarib/features/home/presentation/profile/cubit/profile_state.dart';
import '../cubit/profile_cubit.dart';

import '../repo/profile_repo.dart';


class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfileRepo())..getUserProfile(),
      child: Scaffold(
        backgroundColor: Colors.black, 
        appBar: AppBar(
          title: const Text(
            'Your Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black, 
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A11CB)),
                ),
              );
            } else if (state is ProfileSuccessState) {
              final user = state.userProfileModel;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xff1E1E1E), 
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color:Color(0xFF2575FC), 
                      ),
                    ),
                    const SizedBox(height: 30),

                    
                    _buildProfileInfoTile(
                      title: 'User Name',
                      value: user.userName ?? 'No name available',
                      icon: Icons.account_circle_outlined,
                    ),
                    const SizedBox(height: 14),

                    
                    _buildProfileInfoTile(
                      title: 'Email',
                      value: user.email ?? 'No email available',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 14),

                    
                    
_buildProfileInfoTile(
  title: 'Account Type',
  value: () {
    try {
      
      final String? token = user.token; 
      
      if (token != null && token.isNotEmpty) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        return decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString() ?? 
               decodedToken['role']?.toString() ?? 
               'Not specified';
      }
    } catch (e) {
      print('Error decoding token: $e');
    }
    return CacheHelper.getValue('role')?.toString() ?? 'Not specified';
  }(),
  icon: Icons.assignment_ind_outlined,
),
                    const SizedBox(height: 40),
                
                  ],
                ),
              );
            } else if (state is ProfileErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.white70), // نص أبيض خفيف يتناسب مع الخلفية السوداء
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileCubit>().getUserProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2575FC),
                        ),
                        child: const Text('Try again', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  
  Widget _buildProfileInfoTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff121212), // رمادي داكن مخصص للـ Dark Mode لمنع بهتان التصميم
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2575FC).withValues(alpha: 0.25)), // حدود بنفسجية رقيقة ومضيئة
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2575FC).withValues(alpha: 0.15), // خلفية بنفسجية شفافة خفيفة جداً للايقونة
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2575FC), size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey, // لون نص جانبي هادئ
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white, // النص الأساسي أبيض ساطع وواضح تماماً
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}