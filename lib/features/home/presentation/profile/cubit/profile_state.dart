import 'package:moghtarib/features/home/presentation/profile/model/user_profile_model.dart';


abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {
  final UserProfileModel userProfileModel;
  ProfileSuccessState(this.userProfileModel);
}

class ProfileErrorState extends ProfileStates {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}