import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';

enum GetWorkReportStatus {
  initial,
  loading,
  loaded,
  error,
}

class GetWorkReportState extends Equatable {
  final GetWorkReportStatus status;
  final WorkReportEntity? workReport;
  final String? errorMessage;

  const GetWorkReportState({
    required this.status,
    this.workReport,
    this.errorMessage,
  });

  factory GetWorkReportState.initial() {
    return const GetWorkReportState(
      status: GetWorkReportStatus.initial,
    );
  }

  GetWorkReportState copyWith({
    GetWorkReportStatus? status,
    WorkReportEntity? workReport,
    String? errorMessage,
  }) {
    return GetWorkReportState(
      status: status ?? this.status,
      workReport: workReport ?? this.workReport,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        workReport,
        errorMessage,
      ];
}
