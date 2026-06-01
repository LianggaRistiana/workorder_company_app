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
  final bool shouldRefreshWorkOrder;

  const GetWorkReportState({
    required this.status,
    this.workReport,
    this.errorMessage,
    this.shouldRefreshWorkOrder = false,
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
    bool? shouldRefreshWorkOrder,
  }) {
    return GetWorkReportState(
      status: status ?? this.status,
      workReport: workReport ?? this.workReport,
      errorMessage: errorMessage ?? this.errorMessage,
      shouldRefreshWorkOrder:
          shouldRefreshWorkOrder ?? this.shouldRefreshWorkOrder,
    );
  }

  @override
  List<Object?> get props => [
        status,
        workReport,
        errorMessage,
        shouldRefreshWorkOrder,
      ];
}
