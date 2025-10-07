part of 'services_bloc.dart';

sealed class ServicesEvent {}

class GetServicesRequested extends ServicesEvent {}

class GetServiceByIdRequested extends ServicesEvent {
  final String id;
  GetServiceByIdRequested(this.id);
}
