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

  // ملحوظة: إذا كنت تستخدم مكتبة Equatable، تأكد من عمل extends لـ Equatable فوق، وإلا يمكنك إزالة الـ props لو لم تكن تحتاجها
  @override
  List<Object?> get props => [users];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);
}

// ✨ تحديث نوع البيانات هنا أيضاً ليتوافق مع الـ Model الجديد
class UserDeleting extends UsersState {
  final List<UserModel> users;

  const UserDeleting(this.users);
}

// ✨ وتحديثه هنا أيضاً
class UserDeleted extends UsersState {
  final List<UserModel> users;

  const UserDeleted(this.users);
}
