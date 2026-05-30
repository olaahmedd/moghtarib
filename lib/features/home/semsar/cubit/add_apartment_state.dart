
import 'package:moghtarib/features/home/semsar/model/add_apartment_model.dart';
abstract class ApartmentState {}

/// الحالة الابتدائية عند فتح الشاشة
class ApartmentInitial extends ApartmentState {}

/// حالة التحميل (تُستخدم عند إرسال البيانات أو جلبها)
class ApartmentLoading extends ApartmentState {}

/// حالة النجاح عند إضافة شقة جديدة بنجاح
class ApartmentAddSuccess extends ApartmentState {}

/// حالة النجاح عند جلب قائمة الشقق وتمرير البيانات للواجهة
class ApartmentFetchSuccess extends ApartmentState {
  final List<AddApartmentModel> apartments;
  ApartmentFetchSuccess(this.apartments);
}

/// حالة حدوث خطأ في الـ API مع تمرير رسالة الخطأ
class ApartmentError extends ApartmentState {
  final String message;
  ApartmentError(this.message);
}