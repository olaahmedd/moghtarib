import '../../model/user_model.dart';

abstract class UsersState {
  const UsersState();
}

class UsersInitial extends UsersState {
  const UsersInitial();
}

class UsersLoading extends UsersState {
  const UsersLoading();
}

class UsersLoaded extends UsersState {
  final List<UserModel> users; 

  const UsersLoaded(this.users);

  
  @override
  List<Object?> get props => [users];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);
}


class UserDeleting extends UsersState {
  final List<UserModel> users;

  const UserDeleting(this.users);
}

class UserDeleted extends UsersState {
  final List<UserModel> users;

  const UserDeleted(this.users);
}
