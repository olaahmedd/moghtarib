import 'my_report_state.dart';
import '../../repo/student_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyReportsCubit extends Cubit<MyReportsState> {
  final StudentRepo _repo;
  MyReportsCubit(this._repo) : super(MyReportsInitial());

  Future<void> fetchMyReports() async {
    emit(MyReportsLoading());
    final result = await _repo.getMyReports();
    result.fold(
      (error) => emit(MyReportsError(error)),
      (reports) => emit(MyReportsSuccess(reports)),
    );
  }
}