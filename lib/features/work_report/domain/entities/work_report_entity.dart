import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';

// FIXME : add status date later
class WorkReportEntity extends Equatable {
  final String id;
  final String workOrderId;
  final FilledFormWithHistoryEntity workReportForm;
  final WorkReportApprovalAccess approvalAccess;
  final WorkReportStatus status;
  final UserEntity? approvedBy;

  const WorkReportEntity({
    required this.id,
    required this.workOrderId,
    required this.workReportForm,
    required this.approvalAccess,
    required this.status,
    this.approvedBy,
  });

  @override
  List<Object?> get props => [
        id,
        workOrderId,
        workReportForm,
        approvalAccess,
        status,
        approvedBy,
      ];
}
