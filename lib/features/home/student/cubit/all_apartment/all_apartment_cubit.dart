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
