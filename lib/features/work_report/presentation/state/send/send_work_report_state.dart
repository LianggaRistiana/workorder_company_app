import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';

enum SendWorkReportStatus { initial, loading, success, error }

class SendWorkReportState extends Equatable {
  final SendWorkReportStatus status;
  final WorkReportEntity? workReport;
  final String? errorMessage;

  bool get isLoading => status == SendWorkReportStatus.loading;

  const SendWorkReportState(
      {required this.status, this.workReport, this.errorMessage});

  factory SendWorkReportState.initial() =>
      const SendWorkReportState(status: SendWorkReportStatus.initial);

  SendWorkReportState copyWith(
      {SendWorkReportStatus? status,
      WorkReportEntity? workReport,
      String? errorMessage}) {
    return SendWorkReportState(
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
