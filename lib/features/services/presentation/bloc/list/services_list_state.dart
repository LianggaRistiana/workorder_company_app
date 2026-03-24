import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

enum ServicesListStatus {
  initial,
  loading,
  loaded,
  error,
}

class ServicesListState extends Equatable {
  @override
  List<Object?> get props => [status, services, errorMessage];

  final ServicesListStatus status;
  final List<ServiceSummaryEntity> services;
  final String? errorMessage;

  const ServicesListState({
    required this.status,
    required this.services,
    this.errorMessage,
  });

  ServicesListState copyWith({
    ServicesListStatus? status,
    List<ServiceSummaryEntity>? services,
    String? errorMessage,
  }) {
    return ServicesListState(
      status: status ?? this.status,
      services: services ?? this.services,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
