import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter/material.dart';

import 'package:moghtarib/features/auth/cubit/register/register_state.dart';
import 'package:moghtarib/features/auth/data/auth_repo.dart';

import 'package:moghtarib/core/utils/role_based_navigation.dart';


// class RegisterCubit extends Cubit<RegisterStates> {
//   RegisterCubit() : super(RegisterInitialState());


//   static RegisterCubit get(context) => BlocProvider.of(context);

 
//   final AuthRepo repo = AuthRepo(); 

//   bool isPasswordHidden = true;
//   bool isConfirmPasswordHidden = true;
//   String? selectedRole;
//   void changePasswordVisibility() {
//     isPasswordHidden = !isPasswordHidden;
//     emit(RegisterChangePasswordVisibilityState());
//   }

//   void changeConfirmPasswordVisibility() {
//     isConfirmPasswordHidden = !isConfirmPasswordHidden;
//     emit(RegisterChangePasswordVisibilityState());
//   }

//   void changeSelectedRole(String role) {
//     selectedRole = role;
//     emit(RegisterChangeRoleState()); // تأكدي من كتابة هذا السيتيت في ملف register_state.dart
//   }
//   void userRegister({
//     required String username,
//     required String firstname,
//     required String lastname,
//     required String email,
//     required String password,
//     required String nationalid,
//     required String role,
//     required String phonenumber,
//     required String whatsappnumber,
//   }) async {
//     emit(RegisterLoadingState());

    
//     var result = await repo.register(email: email, password: password,phoneNumber:phonenumber,username: username,firstName:firstname,lastName:lastname,nationalId:nationalid,type:role,whatsappNumber:whatsappnumber);

//     result.fold(
//       (error) {
        
//         emit(RegisterErrorState(error));
//       },
//       (successMessage) {
        
//         emit(RegisterSuccessState());
//       },
//     );
//   }
// }

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
    // 💡 تم تعديل الـ state هنا ليكون مخصصاً للـ Confirm Password إذا كان لديكِ
    emit(RegisterChangePasswordVisibilityState()); 
  }

  void changeSelectedRole(String role) {
    selectedRole = role;
    emit(RegisterChangeRoleState()); 
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
  }) async {
    emit(RegisterLoadingState());

    // الـ repo.register هنا يعود بـ Either<String, UserModel>
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

    result.fold(
      (error) {
        print("DEBUG CUBIT REGISTER ERROR: $error");
        emit(RegisterErrorState(error));
      },
      (userModel) async {
        print("DEBUG CUBIT REGISTER SUCCESS: ${userModel.toString()}");
        emit(RegisterSuccessState(userModel));

        // After register, fetch role and navigate to the correct home screen.
        final role = await repo.fetchUserRole();
        if (role == null) return;

        await RoleBasedNavigation.navigateByRole(
          role: role,
          replace: true,
        );
      },
    );
  }
}