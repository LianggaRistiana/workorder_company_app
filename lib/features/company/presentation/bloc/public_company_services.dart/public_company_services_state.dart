import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

enum PublicCompanyServicesStatus {
  initial,
  loading,
  error,
  loaded,
}

class PublicCompanyServicesState extends Equatable {
  @override
  List<Object?> get props => [status, services, errorMessage];

  final PublicCompanyServicesStatus status;
  final List<ServiceSummaryEntity> services;
  final String? errorMessage;

  const PublicCompanyServicesState({
    this.status = PublicCompanyServicesStatus.initial,
    this.services = const [],
    this.errorMessage,
  });

  PublicCompanyServicesState copyWith({
    PublicCompanyServicesStatus? status,
    List<ServiceSummaryEntity>? services,
    String? errorMessage,
  }) {
    return PublicCompanyServicesState(
      status: status ?? this.status,
      services: services ?? this.services,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
