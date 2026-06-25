import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/presentation/profile/cubit/profile_state.dart';
import 'package:moghtarib/features/home/presentation/profile/repo/profile_repo.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitialState());

  // دالة جلب بيانات المستخدم
  Future<void> getUserProfile() async {
    emit(ProfileLoadingState());
    try {
      final userProfile = await profileRepo.getCurrentUser();
      emit(ProfileSuccessState(userProfile));
    } catch (error) {
      emit(ProfileErrorState(error.toString()));
    }
  }
}