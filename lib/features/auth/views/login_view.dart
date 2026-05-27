import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/home_screens.dart';

import '../../../core/utils/app_colors.dart';
// import '../../../core/widgets/default_text_field.dart';
// import '../../../core/utils/app_assets.dart';

import '../cubit/login/login_cubit.dart';
import '../cubit/login/login_state.dart';


// import '../../../core/widgets/custom_appbar.dart';

// import '../../../core/widgets/custom_btn.dart';

// import 'package:moghtarib/features/screen/welcome.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
      // 👈 انقل المستخدم من هنا إجبارياً بالـ Navigator العادي بتاع فلاتر لتجربة التنقل
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BaseHomeScreen( title: 'Home')),
      );
    }
    if (state is LoginErrorState) {
      // عشان لو في أيرور مخفي يظهرلك في شاشة الموبايل
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
          // navigation happens inside cubit via callback routing in this implementation
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
                          width: 317,
                          height: 55,
                          child: state is LoginLoadingState
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFF83758),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () => cubit.login(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
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
