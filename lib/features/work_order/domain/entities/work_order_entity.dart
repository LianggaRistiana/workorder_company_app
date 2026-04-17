import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_status_date_entity.dart';

class WorkOrderEntity extends Equatable {
  final String id;
  final String code;
  final String configId;
  final String? serviceRequestId;
  final PositionEntity positionOnDuty;
  final ServiceSummaryEntity service;
  final UserEntity? createdBy;
  final UserEntity? approvedBy;
  final WorkOrderAprrovalAccess approvalAccess;
  final int minStaff;
  final int maxStaff;
  final List<UserEntity> assignedStaffs;
  final UserEntity? staffPic;
  final WorkOrderStatus status;
  final FilledFormWithHistoryEntity workOrderForm;
  final bool hasIssue;
  final String? issueNote;
  final WorkOrderStatusDateEntity statusDate;

  const WorkOrderEntity({
    required this.id,
    required this.code,
    this.serviceRequestId,
    required this.positionOnDuty,
    required this.configId,
    required this.service,
    this.createdBy,
    this.approvedBy,
    required this.approvalAccess,
    required this.minStaff,
    required this.maxStaff,
    required this.status,
    required this.assignedStaffs,
    this.staffPic,
    required this.workOrderForm,
    required this.hasIssue,
    this.issueNote,
    required this.statusDate,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        service,
        positionOnDuty,
        minStaff,
        maxStaff,
        staffPic,
        createdBy,
        approvedBy,
        approvalAccess,
        status,
        assignedStaffs,
        workOrderForm,
        hasIssue,
        issueNote,
        statusDate,
      ];
}
