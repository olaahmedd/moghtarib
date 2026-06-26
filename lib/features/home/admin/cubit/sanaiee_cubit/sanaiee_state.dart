import 'package:moghtarib/features/home/admin/model/sanaiee_model.dart';


abstract class SanaieeState {
  const SanaieeState();
}

class SanaieeInitial extends SanaieeState {
  const SanaieeInitial();
}

class SanaieeLoading extends SanaieeState {
  const SanaieeLoading();
}

class SanaieeLoaded extends SanaieeState {
  final List<SanaieeModel> sanaiee; 

  const SanaieeLoaded(this.sanaiee);

 
  @override
  List<Object?> get props => [sanaiee];
}

class SanaieeError extends SanaieeState {
  final String message;

  const SanaieeError(this.message);
}
class OpenWhatsAppLoading extends SanaieeState {}
class OpenWhatsAppSuccess extends SanaieeState {}
class OpenWhatsAppError extends SanaieeState {
  final String message;
  OpenWhatsAppError(this.message);
}


