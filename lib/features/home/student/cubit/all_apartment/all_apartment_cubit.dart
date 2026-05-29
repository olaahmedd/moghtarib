import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/student/cubit/all_apartment/all_apartment_state.dart';
import 'package:moghtarib/features/home/student/model/All_apartment_model.dart';
import 'package:moghtarib/features/home/student/repo/student_repo.dart';


class AllApartmentCubit extends Cubit<ApartmentState> {
  final StudentRepo _repo;
  AllApartmentCubit(this._repo) : super(ApartmentInitial());

  Future<void> fetchAllApartment({String? searchText}) async {
    emit(ApartmentLoading());
    final result = await _repo.getAllApartments(searchText: searchText);

    result.fold(
      (error) => emit(ApartmentError(error)),
      (apartment) => emit(ApartmentLoaded(apartment)),
    );
  }
}
// 📢 غيّري int إلى String هنا في البارامتر:
// Future<void> deleteUser({required String userId}) async {
//   final current = state;
//   if (current is! ApartmentLoaded) return;

//   final List<AllApartmentModel> currentUsers = List.from(current.users);

//   // تمرير الـ String userId بنجاح إلى الـ Repo بدون أخطاء
//   final result = await _repo.deleteUser(userId: userId);

//   result.fold(
//     (error) => emit(UsersError(error)), // تأكدي من اسم الـ State عندك لو مختلف
//     (success) {
//       if (success) {
//         // حذف المستخدم محلياً من القائمة بعد نجاح السيرفر
//         currentUsers.removeWhere((user) => user.id == userId);
//         emit(UsersLoaded(currentUsers));
//       }
//     },
//   );
// }}