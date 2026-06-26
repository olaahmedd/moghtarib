import 'package:moghtarib/features/auth/model/user_model.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  final UserModel userModel;

  RegisterSuccessState(this.userModel); 
}

class RegisterChangeRoleState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String error;
  RegisterErrorState(this.error);
}

class RegisterChangePasswordVisibilityState extends RegisterStates {}
class RegisterChangeConfirmPasswordVisibilityState extends RegisterStates {}

// 🎯 الحالات الجديدة لجلب الأقسام (المهن) ديناميكياً من السيرفر
class RegisterGetDepartmentsLoadingState extends RegisterStates {}
class RegisterGetDepartmentsSuccessState extends RegisterStates {}
class RegisterGetDepartmentsErrorState extends RegisterStates {
  final String error;
  RegisterGetDepartmentsErrorState(this.error);
}