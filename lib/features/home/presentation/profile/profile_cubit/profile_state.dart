abstract class UserState {}

class UserInitial extends UserState {}


class UpdateProfileLoading extends UserState {}

class UpdateProfileSuccess extends UserState {
  final String message;
  UpdateProfileSuccess(this.message);
}

class UpdateProfileError extends UserState {
  final String error;
  UpdateProfileError(this.error);
}


class ChangePasswordLoading extends UserState {}

class ChangePasswordSuccess extends UserState {
  final String message;
  ChangePasswordSuccess(this.message);
}

class ChangePasswordError extends UserState {
  final String error;
  ChangePasswordError(this.error);
}