import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/work_reports_filled_form_entity.dart';

enum GetServiceRequestReportStatus {
  initial,
  loading,
  success,
  error,
}

class GetServiceRequestReportState extends Equatable {
  final GetServiceRequestReportStatus status;
  final WorkReportsFilledFormEntity reports;
  final String? errorMessage;

  bool get isLoading => status == GetServiceRequestReportStatus.loading;
  bool get isSuccess => status == GetServiceRequestReportStatus.success;
  bool get isError => status == GetServiceRequestReportStatus.error;


  const GetServiceRequestReportState({
    required this.status,
    required this.reports,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [
        status,
        reports,
        errorMessage,
      ];
}
