import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_with_history_model.dart';
import 'package:workorder_company_app/features/work_report/data/model/work_report_status_date_model.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';

class WorkReportModel extends WorkReportEntity {
  const WorkReportModel({
    required super.id,
    required super.workOrderId,
    required super.workReportForm,
    required super.showReportToRequester,
    required super.approvalAccess,
    required super.status,
    super.approvedBy,
    required super.statusDate,
  });

  factory WorkReportModel.fromJson(Map<String, dynamic> json) {
    return WorkReportModel(
      id: json.field('_id').reqString(),
      workOrderId: json.field('workOrderId').reqString(),
      showReportToRequester:
          json.field('show_report_to_requester').optBool() ?? false,
      workReportForm: FilledFormWithHistoryModel.fromJson(
          json['reportFormDetail'], json['submissions']),
      approvalAccess: json
          .field('workReportApprovalAccessType')
          .reqEnum(WorkReportApprovalAccess.fromString),
      status: json.field('status').reqEnum(WorkReportStatus.fromString),
      approvedBy: json.field('approvedBy').optModel(UserModel.fromJson),
      statusDate: WorkReportStatusDateModel.fromJson(json),
    );
  }
}
