import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moghtarib/core/utils/app_colors.dart';
import 'package:moghtarib/core/utils/jwt_role_parser.dart';
import 'package:moghtarib/features/auth/cubit/login/login_cubit.dart';
import 'package:moghtarib/features/auth/cubit/login/login_state.dart';
import 'package:moghtarib/features/home/admin/view/admin_home_view.dart';
import '../../home/presentation/views/base_home_screen.dart';
import 'package:moghtarib/features/home/home_screens.dart';


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            
            final token = state.userModel.accessToken;
            final userRole = JwtRoleParser.extractRole(token ?? '');
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
            String role = decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.toString() ?? 
                decodedToken['role']?.toString() ?? '';
  
            role = role.trim().toLowerCase();
            
            if (userRole == 'Admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  
                  builder: (_) => const AdminHomeView(), 
                ),
              );
            } else if (userRole == 'Student') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const StudentHome()),
              );
            } else if (userRole == 'Semsar') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SemsarHome()),
              );
            } else {
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BaseHomeScreen(
                    drawerTitle: 'Home',
                    body: const Center(
                      child: Text(
                        'Home',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
          
          if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              body: SafeArea(
                child: SingleChildScrollView(
                  
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Login to your\naccount',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 30),

                        TextFormField(
                          controller: cubit.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: cubit.inputDecoration(
                            hint: 'Email',
                            icon: Icons.email,
                          ),
                          validator: cubit.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: cubit.passwordController,
                          obscureText: cubit.isPasswordHidden,
                          decoration: cubit.inputDecoration(
                            hint: 'Password',
                            icon: Icons.lock,
                            suffix: IconButton(
                              icon: Icon(
                                cubit.isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: cubit.changePasswordVisibility,
                            ),
                          ),
                          validator: cubit.validatePassword,
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: state is LoginLoadingState
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFF83758),
                                  ),
                                )
                              : Container(width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2575FC).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                                child: ElevatedButton(
                                    onPressed: () => cubit.login(),
                                    style: ElevatedButton.styleFrom(
                                     
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ),
                        ),

                        const SizedBox(height: 18),

                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/register',
                              );
                            },
                            child: Text(
                              "Don’t have an account? Register",
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}