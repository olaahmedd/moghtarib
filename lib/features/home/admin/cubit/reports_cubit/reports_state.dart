import '../../model/report_model.dart';
 abstract class ReportState {}

class ReportInitial extends ReportState {}
class GetReportsLoadingState extends ReportState {}
class GetReportsSuccessState extends ReportState {
  final List<ReportModel> reports;
  GetReportsSuccessState(this.reports);
}
class GetReportsErrorState extends ReportState {
  final String error;
  GetReportsErrorState(this.error);
}

class DeleteReportLoadingState extends ReportState {}

class DeleteReportSuccessState extends ReportState {}

class DeleteReportErrorState extends ReportState {
  final String error;
  DeleteReportErrorState(this.error);
}