import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter/material.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/core/cache/cache_keys.dart';
import 'package:moghtarib/features/auth/cubit/register/register_state.dart';
import 'package:moghtarib/features/auth/data/auth_repo.dart';
import 'package:moghtarib/core/utils/jwt_role_parser.dart';
import 'package:moghtarib/core/utils/role_based_navigation.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  final AuthRepo repo = AuthRepo(); 

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  String? selectedRole;

  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    emit(RegisterChangePasswordVisibilityState());
  }

  void changeConfirmPasswordVisibility() {
    isConfirmPasswordHidden = !isConfirmPasswordHidden;
    emit(RegisterChangePasswordVisibilityState()); 
  }

  void changeSelectedRole(String role) {
    selectedRole = role;
    emit(RegisterChangeRoleState()); 
  }

  // ✨ تم حذف الـ BuildContext تماماً ليكون الكود نظيفاً ومفصولاً عن الـ UI
  void userRegister({
    required String username,
    required String firstname,
    required String lastname,
    required String email,
    required String password,
    required String nationalid,
    required String role,
    required String phonenumber,
    required String whatsappnumber,
  }) async {
    emit(RegisterLoadingState());

    var result = await repo.register(
      email: email, 
      password: password,
      phoneNumber: phonenumber,
      username: username,
      firstName: firstname,
      lastName: lastname,
      nationalId: nationalid,
      type: role,
      whatsappNumber: whatsappnumber,
    );

    await result.fold(
      (error) async {
        print("DEBUG CUBIT REGISTER ERROR: $error");
        emit(RegisterErrorState(error));
      },
      (userModel) async {
        print("DEBUG CUBIT REGISTER SUCCESS: ${userModel.toString()}");

        // 1. حفظ التوكن في الكاش
        await CacheHelper.setValue(
          key: CacheKeys.accessToken, 
          value: userModel.accessToken, 
        );

        final token = userModel.accessToken;
        String? finalRole;
        if (token != null && token.isNotEmpty) {
          finalRole = JwtRoleParser.extractRole(token);
        }
        
        finalRole ??= role;

        if (finalRole.isEmpty) {
          emit(RegisterErrorState('Registration succeeded, but role is missing.'));
          return;
        }

        final normalizedRole = finalRole.toLowerCase();
        
        // 2. حفظ الـ Role في الكاش ليتعرف عليه الـ Splash لاحقاً
        await CacheHelper.setValue(
          key: CacheKeys.userRole, 
          value: normalizedRole,
        );

        // 3. إرسال حالة النجاح للـ UI، وهناك في الـ Listener هيتم التنقل فوراً بـ BuildContext الصفحة
        emit(RegisterSuccessState(userModel));
      },
    );
  }
}