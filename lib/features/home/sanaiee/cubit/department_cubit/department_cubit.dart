import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/sanaiee/cubit/department_cubit/department_state.dart';
import '../../repo/sanaiee_repo.dart';
import 'department_state.dart'; 
import '../../model/department_model.dart';
class DepartmentCubit extends Cubit<DepartmentState> {
  final SanaieeRepo _repo;
  DepartmentCubit(this._repo) : super(DepartmentInitial());

  Future<void> sendDepartment(String name) async {
    emit(DepartmentLoading()); 
    try {
      
      await _repo.addDepartment(name);
      emit(DepartmentSuccess()); 
    } catch (e) {
      emit(DepartmentError(e.toString())); 
    }
  }
}