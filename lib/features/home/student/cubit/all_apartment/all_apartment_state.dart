

import 'package:moghtarib/features/home/student/model/All_apartment_model.dart';

abstract class ApartmentState {
  const ApartmentState();
}

class ApartmentInitial extends ApartmentState {
  const ApartmentInitial();
}

class ApartmentLoading extends ApartmentState {
  const ApartmentLoading();
}

class ApartmentLoaded extends ApartmentState {
  final List<AllApartmentModel> apartment; 

  const ApartmentLoaded(this.apartment);

  
  @override
  List<Object?> get props => [apartment];
}

class ApartmentError extends ApartmentState {
  final String message;

  const ApartmentError(this.message);
}

