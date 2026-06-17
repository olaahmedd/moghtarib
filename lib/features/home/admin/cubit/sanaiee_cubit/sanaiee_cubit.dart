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
      
      
      emit(SanaieeInitial()); 
    } catch (e) {
      emit(OpenWhatsAppError(e.toString()));
      
     
      emit(SanaieeInitial()); 
    }
  }
}

