import 'package:moghtarib/features/home/admin/cubit/reports_cubit/reports_state.dart';
import '../../repo/admin_repo.dart';
import '../../model/report_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ReportCubit extends Cubit<ReportState> {
  final AdminRepo adminRepo;
  ReportCubit(this.adminRepo) : super(ReportInitial());

  List<ReportModel> reports = [];

  Future <void> fetchReports() async {
    emit(GetReportsLoadingState());
    
    final result = await adminRepo.getAllReports();
    
    result.fold(
      (error) => emit(GetReportsErrorState(error)),
      (list) {
        reports = list;
        emit(GetReportsSuccessState(reports));
      },
      
    );
    
  }
Future<void> deleteReport(String reportId) async {
 
  final result = await adminRepo.deleteReport(reportId);
  
  result.fold(
    (error) {
     
      emit(GetReportsErrorState(error));
    },
    (success) async {
      
      await fetchReports(); 
    },
  );
}

}