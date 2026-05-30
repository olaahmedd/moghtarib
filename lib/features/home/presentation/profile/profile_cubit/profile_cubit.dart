import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/presentation/profile/profile_repo/profile_repo.dart';
import '../profile_cubit/profile_state.dart';


class UserCubit extends Cubit<UserState> {
  final UserRepo userRepo;
  UserCubit(this.userRepo) : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of(context);

  // تعريف الـ Controllers الثلاثة المطلوبة في الـ UI
  var emailController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  void changePassword() async {
    // 1. التحقق من المدخلات
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
    
    // 2. استدعاء الـ Repo وتمرير الإيميل والباسورد
    final result = await userRepo.changePassword(
      email: emailController.text, // الخطأ هنا هيختفي لأن الـ Repo بقا بيستقبله
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