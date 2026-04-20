import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';

enum SubmitWorkReportSubmissionStatus { initial, loading, success, error }

class SubmitWorkReportSubmissionState extends Equatable {
  final SubmitWorkReportSubmissionStatus status;
  final WorkReportEntity? workReport;
  final String? errorMessage;

  bool get isLoading => status == SubmitWorkReportSubmissionStatus.loading;

  const SubmitWorkReportSubmissionState(
      {required this.status, this.workReport, this.errorMessage});

  factory SubmitWorkReportSubmissionState.initial() =>
      const SubmitWorkReportSubmissionState(
          status: SubmitWorkReportSubmissionStatus.initial);

  SubmitWorkReportSubmissionState copyWith(
      {SubmitWorkReportSubmissionStatus? status,
      WorkReportEntity? workReport,
      String? errorMessage}) {
    return SubmitWorkReportSubmissionState(
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
