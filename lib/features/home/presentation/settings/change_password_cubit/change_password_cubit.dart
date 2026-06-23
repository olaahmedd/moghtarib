import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/presentation/settings/change_password_repo/change_password_repo.dart';
import 'change_password_state.dart';


class UserCubit extends Cubit<UserState> {
  final UserRepo userRepo;
  UserCubit(this.userRepo) : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of(context);

  
  var emailController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  void changePassword() async {
    
    if (emailController.text.isEmpty) {
      emit(ChangePasswordError("برجاء إدخال البريد الإلكتروني"));
      return;
    }
    
    if (newPasswordController.text != confirmPasswordController.text) {
      emit(ChangePasswordError("كلمتا المرور غير متطابقتين"));
      return;
    }

    if (newPasswordController.text.isEmpty) {
      emit(ChangePasswordError("برجاء إدخال كلمة المرور الجديدة"));
      return;
    }

    emit(ChangePasswordLoading());
    
    
    final result = await userRepo.changePassword(
      email: emailController.text, 
      newPassword: newPasswordController.text,
    );
    
    result.fold(
      (error) => emit(ChangePasswordError(error)),
      (message) => emit(ChangePasswordSuccess(message)),
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}