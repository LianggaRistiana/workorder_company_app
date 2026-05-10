import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/dashboard/domain/entitties/service_request_stats_entity.dart';

enum ServiceRequestStatsStatus {
  initial,
  loading,
  loaded,
  error,
}

class ServiceRequestStatsState extends Equatable {
  final ServiceRequestStatsStatus status;
  final PeriodType periodType;
  final ServiceRequestStatsEntity? stats;
  final String? errorMessage;

  const ServiceRequestStatsState({
    this.status = ServiceRequestStatsStatus.initial,
    required this.periodType,
    this.stats,
    this.errorMessage,
  });

  ServiceRequestStatsState copyWith({
    ServiceRequestStatsStatus? status,
    ServiceRequestStatsEntity? stats,
    PeriodType? periodType,
    String? errorMessage,
  }) {
    return ServiceRequestStatsState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      periodType: periodType ?? this.periodType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, errorMessage];
}
