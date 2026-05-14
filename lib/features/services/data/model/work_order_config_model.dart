import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/work_order_config_entity.dart';

class WorkOrderConfigModel extends WorkOrderConfigEntity {
  const WorkOrderConfigModel({
    required super.workOrderForm,
    required super.workReportForm,
    required super.positionOnDuty,
    required super.workOrderAprrovalAccessType,
    required super.workReportApprovalAccessType,
    required super.minStaff,
    required super.maxStaff,
  });

  factory WorkOrderConfigModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderConfigModel(
      workOrderForm: json.field("workOrderForm").reqModel(FormModel.fromJson),
      workReportForm: json.field("workReportForm").reqModel(FormModel.fromJson),
      positionOnDuty:
          json.field("positionsOnDuty").reqModel(PositionModel.fromJson),
      workOrderAprrovalAccessType: json
          .field("workOrderApprovalAccessType")
          .reqEnum(WorkOrderAprrovalAccess.fromString),
      workReportApprovalAccessType: json
          .field("workReportApprovalAccessType")
          .reqEnum(WorkReportApprovalAccess.fromString),
      minStaff: json.field("minStaff").reqInt(),
      maxStaff: json.field("maxStaff").reqInt(),
    );
  }

  factory WorkOrderConfigModel.fromJsonTemplate(Map<String, dynamic> json) {
    return WorkOrderConfigModel(
      workOrderForm:
          json.field("workOrderForm").optModel(FormModel.fromJsonTemplate),
      workReportForm:
          json.field("workReportForm").reqModel(FormModel.fromJsonTemplate),
      positionOnDuty: json
          .field("positionsOnDuty")
          .reqModel(PositionModel.fromJsonTemplate),
      workOrderAprrovalAccessType: json
          .field("workOrderApprovalAccessType")
          .reqEnum(WorkOrderAprrovalAccess.fromString),
      workReportApprovalAccessType: json
          .field("workReportApprovalAccessType")
          .reqEnum(WorkReportApprovalAccess.fromString),
      minStaff: json.field("minStaff").reqInt(),
      maxStaff: json.field("maxStaff").reqInt(),
    );
  }

  factory WorkOrderConfigModel.fromEntity(WorkOrderConfigEntity entity) {
    return WorkOrderConfigModel(
      workOrderForm: entity.workOrderForm,
      workReportForm: entity.workReportForm,
      positionOnDuty: entity.positionOnDuty,
      workOrderAprrovalAccessType: entity.workOrderAprrovalAccessType,
      workReportApprovalAccessType: entity.workReportApprovalAccessType,
      minStaff: entity.minStaff,
      maxStaff: entity.maxStaff,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "workOrderFormId": workOrderForm?.id,
      "workReportFormId": workReportForm.id,
      "positionId": positionOnDuty.id, // HACK : POTENTIALLY NULL
      "workOrderApprovalAccessType": workOrderAprrovalAccessType.toSnakeCase(),
      "workReportApprovalAccessType":
          workReportApprovalAccessType.toSnakeCase(),
      "minStaff": minStaff,
      "maxStaff": maxStaff,
    };
  }
}
