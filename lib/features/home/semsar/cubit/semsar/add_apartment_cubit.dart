import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/semsar/cubit/semsar/add_apartment_state.dart';
import '../../model/add_apartment_model.dart';
import '../../repo/add_apartment_repo.dart';
class ApartmentCubit extends Cubit<ApartmentState> {
  final ApartmentRepo apartmentRepo;

  ApartmentCubit(this.apartmentRepo) : super(ApartmentInitial());
  Future<void> addApartment({
    required AddApartmentModel apartment,
    required File? baseImage,
    required List<File> additionalImages,
  }) async {
    emit(ApartmentLoading());

    try {
      final response = await apartmentRepo.addApartment(
        apartment: apartment,
        baseImage: baseImage,
        additionalImages: additionalImages,
      );  

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ApartmentAddSuccess());
      } else {
        emit(ApartmentError("Failed to add apartment : ${response.statusMessage}"));
      }
    } catch (error) {
      String errorMessage = error.toString();
      if (errorMessage.startsWith("Exception: ")) {
        errorMessage = errorMessage.replaceFirst("Exception: ", "");
      }
      emit(ApartmentError(errorMessage));
    }
  }
  Future<void> updateApartment({    required AddApartmentModel apartment,
    File? baseImage,
  }) async {
    emit(ApartmentLoading());

    try {
  
      await apartmentRepo.updateApartment(
        apartment: apartment,
        baseImage: baseImage,
      );

      emit(ApartmentAddSuccess());
    } catch (error) {
      emit(ApartmentError(error.toString()));
    }
  }
}