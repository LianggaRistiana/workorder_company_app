import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/workreport/domain/entitties/work_report_entity.dart';

enum WorkReportStateStatus {
  initial,
  loading,
  loaded,
  error,
  success,
}

class WorkReportState extends Equatable {
  final WorkReportStateStatus status;
  final WorkReportEntity? workReport;
  final String? errorMessage;

  const WorkReportState({
    this.status = WorkReportStateStatus.initial,
    this.workReport,
    this.errorMessage,
  });

  WorkReportState copyWith({
    WorkReportStateStatus? status,
    WorkReportEntity? workReport,
    String? errorMessage,
  }) {
    return WorkReportState(
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

class WorkReportSubmitState extends Equatable {
  final WorkReportStateStatus status;
  final String? errorMessage;

  const WorkReportSubmitState({
    this.status = WorkReportStateStatus.initial,
    this.errorMessage,
  });

  WorkReportSubmitState copyWith({
    WorkReportStateStatus? status,
    String? errorMessage,
  }) {
    return WorkReportSubmitState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];
}
