import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/work_order_config_entity.dart';

class WorkOrderConfigModel extends WorkOrderConfigEntity {
  const WorkOrderConfigModel(
      {required super.workOrderForm,
      required super.workReportForm,
      required super.positionOnDuty,
      required super.workOrderAprrovalAccessType,
      required super.workReportApprovalAccessType,
      required super.minStaff,
      required super.maxStaff});

  factory WorkOrderConfigModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderConfigModel(
      workOrderForm: FormModel.fromJson(json["workOrderForm"]),
      workReportForm: FormModel.fromJson(json["workReportForm"]),
      positionOnDuty: PositionModel.fromJson(json["positionsOnDuty"]),
      workOrderAprrovalAccessType: WorkOrderAprrovalAccess.fromString(
          safeParse<String>(json, "workOrderApprovalAccessType")
          ),
      workReportApprovalAccessType: WorkReportApprovalAccess.fromString(
          safeParse<String>(json, "workReportApprovalAccessType")),
      minStaff: safeParse<int>(json, "minStaff"),
      maxStaff: safeParse<int>(json, "maxStaff"),
    );
  }
}
