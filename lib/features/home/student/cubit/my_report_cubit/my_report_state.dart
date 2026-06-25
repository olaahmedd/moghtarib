import '../../model/my_report_model.dart';

abstract class MyReportsState {}

class MyReportsInitial extends MyReportsState {}
class MyReportsLoading extends MyReportsState {}
class MyReportsSuccess extends MyReportsState {
  final List<ReportModel> reports;
  MyReportsSuccess(this.reports);
}
class MyReportsError extends MyReportsState {
  final String message;
  MyReportsError(this.message);
}


class DeleteReportLoadingState extends MyReportsState {}

class DeleteReportSuccessState extends MyReportsState {}

class DeleteReportErrorState extends MyReportsState {
  final String error;
  DeleteReportErrorState(this.error);
}