import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_with_history_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_status_date_model.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

class WorkOrderModel extends WorkOrderEntity {
  const WorkOrderModel({
    required super.id,
    required super.code,
    required super.configId,
    required super.service,
    required super.createdBy,
    required super.approvedBy,
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
      id: json.field('id').reqString(),
      code: json.field('code').reqString(),
      configId: json.field('configId').reqString(),
      serviceRequestId: json.field('serviceRequestId').optString(),
      service: json.field('service').reqModel(ServiceSummaryModel.fromJson),
      createdBy: json.field('createdBy').reqModel(UserModel.fromJson),
      approvedBy: json.field('approvedBy').reqModel(UserModel.fromJson),
      approvalAccess: json
          .field('approvalAccess')
          .reqEnum(WorkOrderAprrovalAccess.fromString),
      minStaff: json.field('minstaff').reqInt(),
      maxStaff: json.field('maxstaff').reqInt(),
      status: json.field('status').reqEnum(WorkOrderStatus.fromString),
      assignedStaffs:
          json.field('assignedStaffs').reqListModel(UserModel.fromJson),
      workOrderForm: FilledFormWithHistoryModel.fromJson(
          json['reviewForm'], json['reviewSubmission']),
      hasIssue: json.field('hasIssue').reqBool(),
      statusDate:
          json.field('statusDate').reqModel(WorkOrderStatusDateModel.fromJson),
      issueNote: json.field('issueNote').optString(),
    );
  }
}
