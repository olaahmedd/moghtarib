abstract class DepartmentState {}

class DepartmentInitial extends DepartmentState {}
class DepartmentLoading extends DepartmentState {}
class DepartmentSuccess extends DepartmentState {} 
class DepartmentError extends DepartmentState {
  final String error;
  DepartmentError(this.error);
}