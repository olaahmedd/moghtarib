

import 'package:moghtarib/features/home/student/model/All_apartment_model.dart';

abstract class ApartmentState {
  const ApartmentState();
}

class ApartmentInitial extends ApartmentState {
  const ApartmentInitial();
}

class ApartmentLoading extends ApartmentState {
  const ApartmentLoading();
}

class ApartmentLoaded extends ApartmentState {
  final List<AllApartmentModel> apartment; 

  const ApartmentLoaded(this.apartment);

  // ملحوظة: إذا كنت تستخدم مكتبة Equatable، تأكد من عمل extends لـ Equatable فوق، وإلا يمكنك إزالة الـ props لو لم تكن تحتاجها
  @override
  List<Object?> get props => [apartment];
}

class ApartmentError extends ApartmentState {
  final String message;

  const ApartmentError(this.message);
}

// ✨ تحديث نوع البيانات هنا أيضاً ليتوافق مع الـ Model الجديد
// class UserDeleting extends ApartmentState {
//   final List<AllApartmentModel> apartment;

//   const UserDeleting(this.users);
// }

// // ✨ وتحديثه هنا أيضاً
// class UserDeleted extends UsersState {
//   final List<AllApartmentModel> users;

//   const UserDeleted(this.users);
// }
