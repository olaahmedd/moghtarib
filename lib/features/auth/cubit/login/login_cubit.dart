import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/auth/data/auth_repo.dart';
import 'package:moghtarib/features/auth/cubit/login/login_state.dart';
import 'package:moghtarib/core/utils/role_based_navigation.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/core/cache/cache_keys.dart';
import 'package:moghtarib/core/utils/jwt_role_parser.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  final AuthRepo repo = AuthRepo();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;

  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    emit(LoginInitialState());
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final v = value.trim();
    if (!v.contains('@')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoadingState());

    final result = await repo.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    await result.fold(
      (error) async {
        emit(LoginErrorState(error));
      },
      (userModel) async {
        
        await CacheHelper.setValue(
          key: CacheKeys.accessToken, 
          value: userModel.accessToken, 
        );
        
        emit(LoginSuccessState(userModel));

        
        final token = userModel.accessToken; 

        if (token == null || token.isEmpty) {
          emit(LoginErrorState('Missing token after login'));
          return;
        }

        
        final role = JwtRoleParser.extractRole(token);
        if (role == null) {
          emit(LoginErrorState('Invalid token: role not found'));
          return;
        }

        
        await RoleBasedNavigation.navigateByRole(
          role: role,
          replace: true,
        );
      },
    );
  }
}
