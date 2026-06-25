abstract class AddReportState {}
class AddReportInitial extends AddReportState {}
class AddReportLoading extends AddReportState {}
class AddReportSuccess extends AddReportState {}
class AddReportError extends AddReportState {
  final String message;
  AddReportError(this.message);
}