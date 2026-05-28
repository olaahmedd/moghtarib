import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/admin_repo.dart';
import'package:moghtarib/features/home/admin/cubit/sanaiee_cubit/sanaiee_state.dart';
import 'package:url_launcher/url_launcher.dart';

class SanaieeCubit extends Cubit<SanaieeState> {
  final AdminRepo _repo;
  SanaieeCubit(this._repo) : super(SanaieeInitial());

  Future<void> fetchSanaiee({String? searchText}) async {
    emit(SanaieeLoading());
    final result = await _repo.getAllSanaieeia(searchText: searchText);

    result.fold(
      (error) => emit(SanaieeError(error)),
      (sanaiee) => emit(SanaieeLoaded(sanaiee)),
    );
  }
  Future<void> contactViaWhatsApp(String phoneNumber) async {
    emit(OpenWhatsAppLoading());
    try {
      await _repo.openWhatsApp(phoneNumber);
      emit(OpenWhatsAppSuccess());
      
      // 💡 خطوة ذكية: أعد الـ Cubit للحالة المستقرة بعد الفتح مباشرة
      // حتى إذا عاد المستخدم للخلف يجد الزر طبيعياً وليس معلقاً على التحميل أو النجاح.
      emit(SanaieeInitial()); // أو الحالة التي تعرض البيانات لديك مثل FetchSanaieeDataSuccess
    } catch (e) {
      emit(OpenWhatsAppError(e.toString()));
      
      // أعده للحالة الأصلية بعد الخطأ أيضاً لكي يتمكن من المحاولة مجدداً
      emit(SanaieeInitial()); 
    }
  }
}
// 📢 غيّري int إلى String هنا في البارامتر:

