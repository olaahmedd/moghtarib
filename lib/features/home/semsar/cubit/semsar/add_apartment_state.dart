
import 'package:moghtarib/features/home/semsar/model/add_apartment_model.dart';
abstract class ApartmentState {}


class ApartmentInitial extends ApartmentState {}


class ApartmentLoading extends ApartmentState {}


class ApartmentAddSuccess extends ApartmentState {}


class ApartmentFetchSuccess extends ApartmentState {
  final List<AddApartmentModel> apartments;
  ApartmentFetchSuccess(this.apartments);
}


class ApartmentError extends ApartmentState {
  final String message;
  ApartmentError(this.message);
}