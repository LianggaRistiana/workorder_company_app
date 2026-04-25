import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_with_history_model.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_status_date_model.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

class WorkOrderModel extends WorkOrderEntity {
  const WorkOrderModel({
    required super.id,
    required super.code,
    required super.configId,
    required super.positionOnDuty,
    required super.service,
    super.createdBy,
    super.approvedBy,
    required super.approvalAccess,
    required super.minStaff,
    required super.maxStaff,
    required super.status,
    required super.assignedStaffs,
    required super.workOrderForm,
    required super.hasIssue,
    required super.statusDate,
    super.serviceRequestId,
    super.staffPic,
    super.issueNote,
  });

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      id: json.field('_id').reqString(),
      code: json.field('code').reqString(),
      configId: json.field('configId').reqString(),
      service: json.field('service').reqModel(ServiceSummaryModel.fromJson),
      positionOnDuty:
          json.field('positionsOnDuty').reqModel(PositionModel.fromJson),
      serviceRequestId: json.field('serviceRequestId').optString(),
      createdBy: json.field('createdBy').optModel(UserModel.fromJson),
      approvedBy: json.field('approvedBy').optModel(UserModel.fromJson),
      approvalAccess: json
          .field('workOrderApprovalAccessType')
          .reqEnum(WorkOrderAprrovalAccess.fromString),
      minStaff: json.field('minStaff').reqInt(),
      maxStaff: json.field('maxStaff').reqInt(),
      status: json.field('status').reqEnum(WorkOrderStatus.fromString),
      staffPic: json.field('staffPIC').optModel(UserModel.fromJson),
      assignedStaffs:
          json.field('assignedStaff').reqListModel(UserModel.fromJson),
      workOrderForm: FilledFormWithHistoryModel.fromJson(
          json['workOrderForm'], json['submissions']),
      hasIssue: json.field('has_issue').reqBool(),
      statusDate: WorkOrderStatusDateModel.fromJson(json),
      issueNote: json.field('issue_note').optString(),
    );
  }
}
