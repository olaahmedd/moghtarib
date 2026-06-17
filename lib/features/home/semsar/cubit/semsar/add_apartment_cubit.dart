import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/semsar/cubit/semsar/add_apartment_state.dart';
import '../../model/add_apartment_model.dart';
import '../../repo/add_apartment_repo.dart'; // تأكد من مسار الـ Repo عندك


// class ApartmentCubit extends Cubit<ApartmentState> {
//   final ApartmentRepo apartmentRepo;

//   ApartmentCubit(this.apartmentRepo) : super(ApartmentInitial());

//   Future<void> addApartment({
//     required AddApartmentModel apartment,
//     required File? baseImage,
//     required List<File> additionalImages,
//   }) async {
//     emit(ApartmentLoading());

//     try {
      
//       final response = await apartmentRepo.addApartment(
//         apartment: apartment,
//         baseImage: baseImage,
//         additionalImages: additionalImages,
//       );  
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         emit(ApartmentAddSuccess());
//       } else {
//         emit(ApartmentError("فشل في إضافة الشقة: ${response.statusMessage}"));
//       }
//     } catch (error) {
     
//       String errorMessage = error.toString();
//       if (errorMessage.startsWith("Exception: ")) {
//         errorMessage = errorMessage.replaceFirst("Exception: ", "");
//       }
      
//       emit(ApartmentError(errorMessage));
//     }
//   }
// }

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
      // 🚀 استدعاء دالة الـ Repo بالمعاملات الأصلية دون تغيير
      // الـ Repo سيقوم تلقائياً بجلب التوكن من الكاش وإضافته للهيدر داخلياً
      final response = await apartmentRepo.addApartment(
        apartment: apartment,
        baseImage: baseImage,
        additionalImages: additionalImages,
      );  

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ApartmentAddSuccess());
      } else {
        emit(ApartmentError("فشل في إضافة الشقة: ${response.statusMessage}"));
      }
    } catch (error) {
      // معالجة نصوص الأخطاء وعرضها بشكل نظيف للمستخدم
      String errorMessage = error.toString();
      if (errorMessage.startsWith("Exception: ")) {
        errorMessage = errorMessage.replaceFirst("Exception: ", "");
      }
      
      emit(ApartmentError(errorMessage));
    }
  }
}