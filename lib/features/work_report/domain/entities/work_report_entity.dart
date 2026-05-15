import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_status_date_entity.dart';

class WorkReportEntity extends Equatable {
  final String id;
  final String workOrderId;
  final FilledFormWithHistoryEntity workReportForm;
  final WorkReportApprovalAccess approvalAccess;
  final WorkReportStatus status;
  final bool showReportToRequester;
  final UserEntity? approvedBy;
  final WorkReportStatusDateEntity statusDate;

  const WorkReportEntity({
    required this.id,
    required this.workOrderId,
    required this.workReportForm,
    required this.showReportToRequester,
    required this.approvalAccess,
    required this.status,
    this.approvedBy,
    required this.statusDate,
  });

  @override
  List<Object?> get props => [
        id,
        workOrderId,
        workReportForm,
        showReportToRequester,
        approvalAccess,
        status,
        approvedBy,
      ];
}
