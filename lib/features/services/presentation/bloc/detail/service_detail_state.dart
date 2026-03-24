import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

enum ServiceDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

class ServiceDetailState extends Equatable {
  final ServiceDetailStatus status;
  final ServiceEntity? service;
  final String? errorMessage;

  const ServiceDetailState({
    required this.status,
    this.service,
    this.errorMessage,
  });

  factory ServiceDetailState.initial() {
    return const ServiceDetailState(
      status: ServiceDetailStatus.initial,
    );
  }

  ServiceDetailState copyWith({
    ServiceDetailStatus? status,
    ServiceEntity? service,
    String? errorMessage,
  }) {
    return ServiceDetailState(
      status: status ?? this.status,
      service: service ?? this.service,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, service, errorMessage];
}
