import '../../repo/student_repo.dart';
import '../../model/add_report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moghtarib/features/home/student/cubit/add_report_cubit/add_report_state.dart';
import 'package:flutter/material.dart';
import '../my_report_cubit/my_report_cubit.dart';

class AddReportCubit extends Cubit<AddReportState> {
  final StudentRepo _repo;
  AddReportCubit(this._repo) : super(AddReportInitial());

Future<void> sendReport(String text, BuildContext context) async {
  emit(AddReportLoading());
  final result = await _repo.addReport(report: AddReportModel(text: text));
  
  result.fold(
    (error) => emit(AddReportError(error)),
    (success) {
      // 1. نجاح الإضافة
      emit(AddReportSuccess());
      
      // 2. تحديث قائمة التقارير فوراً
      context.read<MyReportsCubit>().fetchMyReports();
    },
  );
}
}