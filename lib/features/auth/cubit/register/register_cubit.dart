import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter/material.dart';
import 'package:moghtarib/core/cache/cache_helper.dart';
import 'package:moghtarib/core/cache/cache_keys.dart';
import 'package:moghtarib/features/auth/cubit/register/register_state.dart';
import 'package:moghtarib/features/auth/data/auth_repo.dart';
import 'package:moghtarib/core/utils/jwt_role_parser.dart';
class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  final AuthRepo repo = AuthRepo(); 

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  String? selectedRole;
  List<dynamic> departments = []; 

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

  void getDepartmentsData() async {
    emit(RegisterGetDepartmentsLoadingState());

    var result = await repo.getDepartments();

    result.fold(
      (error) {
        print("CUBIT GET DEPARTMENTS ERROR: $error");
        emit(RegisterGetDepartmentsErrorState(error));
      },
      (data) {
        departments = data; 
        print("CUBIT GET DEPARTMENTS SUCCESS, COUNT: ${departments.length}");
        emit(RegisterGetDepartmentsSuccessState());
      },
    );
  }

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
    String? departmentId, 
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
      departmentId: departmentId, 
    );

    await result.fold(
      (error) async {
        print("DEBUG CUBIT REGISTER ERROR: $error");
        emit(RegisterErrorState(error));
      },
      (userModel) async {
        print("DEBUG CUBIT REGISTER SUCCESS: ${userModel.toString()}");

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
        
        await CacheHelper.setValue(
          key: CacheKeys.userRole, 
          value: normalizedRole,
        );
        emit(RegisterSuccessState(userModel));
      },
    );
  }
}