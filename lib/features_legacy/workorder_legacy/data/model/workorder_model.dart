// import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
// import 'package:workorder_company_app/features/forms/data/model/filled_form_with_history_model.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/data/models/service_model.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/entitties/workorder__entity.dart';

class WorkorderModel extends WorkorderEntity {
  WorkorderModel({
    required super.id,
    required super.companyId,
    required super.clientServiceRequestId,
    required super.createdAt,
    required super.service,
    // required super.status,
    super.relatedWorkOrderId,
    super.assignedStaffs,
    super.startedAt,
    super.completedAt,
    super.workorderForms,
    required super.createdBy,
  });

  factory WorkorderModel.fromJson(Map<String, dynamic> json) {
    return WorkorderModel(
        id: safeParse<String>(json, "_id"),
        companyId: safeParse<String>(json, "companyId"),
        clientServiceRequestId:
            safeParse<String>(json, "clientServiceRequestId"),
        createdAt: DateTime.parse(safeParse<String>(json, "createdAt")),
        service: ServiceModel.fromJson(json['service']),
        // status: WorkOrderStatus.fromString(json['status']),
        createdBy: UserModel.fromJson(json['createdBy']),
        assignedStaffs: safeParse<List<dynamic>?>(json, "assignedStaffs",
                    requiredField: false)
                ?.map((e) => UserModel.fromJson(e))
                .toList() ??
            [],
        relatedWorkOrderId: safeParse<String?>(json, "relatedWorkOrderId",
            requiredField: false),
        startedAt: safeParse<DateTime?>(
          json,
          'startedAt',
          requiredField: false,
          parser: (value) => DateTime.parse(value as String),
        ),
        completedAt: safeParse<DateTime?>(
          json,
          "completedAt",
          requiredField: false,
          parser: (value) => DateTime.parse(value as String),
        ),
        workorderForms: null);
  }
}
