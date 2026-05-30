import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/semsar/cubit/add_apartment_state.dart';
import '../../model/add_apartment_model.dart';
import '../../repo/add_apartment_repo.dart'; // تأكد من مسار الـ Repo عندك


// class ApartmentCubit extends Cubit<ApartmentState> {
//   final ApartmentRepo apartmentRepo; // 💡 تأكد من اسم الكلاس المحدث ApartmentRepo

//   ApartmentCubit(this.apartmentRepo) : super(ApartmentInitial());

//   Future<void> addApartment({
//     required AddApartmentModel apartment,
//     required File? baseImage,
//     required List<File> additionalImages,
//   }) async {
//     emit(ApartmentLoading());

//     try {
//       // ✅ استدعاء الدالة وانتظار الـ Response
//       final response = await apartmentRepo.addApartment(
//         apartment: apartment,
//         baseImage: baseImage,
//         additionalImages: additionalImages,
//       );

//       // التحقق من نجاح العملية بناءً على الـ StatusCode القادم من السيرفر
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         emit(ApartmentAddSuccess());
//       } else {
//         emit(ApartmentError("Failed to add apartment: ${response.statusMessage}"));
//       }
//     } catch (error) {
//       // ✅ هنا يتم التقاط نص الخطأ المنسق القادم من دالة _handleDioError في الـ Repo
//       emit(ApartmentError(error.toString()));
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
      // ✅ استدعاء الدالة المحدثة وانتظار الـ Response من الـ Repo
      final response = await apartmentRepo.addApartment(
        apartment: apartment,
        baseImage: baseImage,
        additionalImages: additionalImages,
      );

      // التحقق من نجاح العملية بناءً على الـ StatusCode القادم من السيرفر
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ApartmentAddSuccess());
      } else {
        emit(ApartmentError("فشل في إضافة الشقة: ${response.statusMessage}"));
      }
    } catch (error) {
      // ✅ معالجة ذكية لنص الخطأ: إذا كان الخطأ عبارة عن نص قادم من Repo نقوم بتمريره مباشرة
      // لمنع ظهور كلمة 'Exception:' المزعجة في شاشة الـ UI للمستخدم.
      String errorMessage = error.toString();
      if (errorMessage.startsWith("Exception: ")) {
        errorMessage = errorMessage.replaceFirst("Exception: ", "");
      }
      
      emit(ApartmentError(errorMessage));
    }
  }
}