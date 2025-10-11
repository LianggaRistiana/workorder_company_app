part of 'services_bloc.dart';

sealed class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesError extends ServicesState {
  final String message;
  
  ServicesError(this.message);
}

class ServicesLoaded extends ServicesState {
  final List<ServiceEntity>? services;
  final ServiceEntity? selectedService;
  final bool isSubLoading;
  final String? errorMessage;

  ServicesLoaded({
    required this.services,
    this.selectedService,
    this.isSubLoading = false,
    this.errorMessage,
  });

  ServicesLoaded copyWith(
      {List<ServiceEntity>? services,
      ServiceEntity? selectedService,
      bool? isSubLoading,
      String? errorMessage}) {
    return ServicesLoaded(
      services: services ?? this.services,
      selectedService: selectedService ?? this.selectedService,
      isSubLoading: isSubLoading ?? this.isSubLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
