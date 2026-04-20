import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';

enum ApprovalWorkReportStatus { initial, loading, approved, rejected, error }

class ApprovalWorkReportState extends Equatable {
  final ApprovalWorkReportStatus status;
  final WorkReportEntity? workReport;
  final String? errorMessage;

  bool get isRejected => status == ApprovalWorkReportStatus.rejected;
  bool get isApproved => status == ApprovalWorkReportStatus.approved;
  bool get isSuccess => isApproved || isRejected;

  const ApprovalWorkReportState({
    required this.status,
    this.workReport,
    this.errorMessage,
  });

  factory ApprovalWorkReportState.initial() =>
      const ApprovalWorkReportState(status: ApprovalWorkReportStatus.initial);

  ApprovalWorkReportState copyWith({
    ApprovalWorkReportStatus? status,
    WorkReportEntity? workReport,
    String? errorMessage,
  }) {
    return ApprovalWorkReportState(
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
