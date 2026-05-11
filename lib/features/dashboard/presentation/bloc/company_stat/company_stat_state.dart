import 'package:workorder_company_app/features/dashboard/domain/entitties/company_stats_entity.dart';

enum CompanyStatStatus {
  initial,
  loading,
  loaded,
  error,
}

class CompanyStatState {
  final CompanyStatStatus status;
  final CompanyStatsEntity? stats;
  final String? errorMessage;

  const CompanyStatState({
    this.status = CompanyStatStatus.initial,
    this.stats,
    this.errorMessage,
  });

  CompanyStatState copyWith({
    CompanyStatStatus? status,
    CompanyStatsEntity? stats,
    String? errorMessage,
  }) {
    return CompanyStatState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
