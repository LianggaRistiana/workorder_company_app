import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/domain/entitties/work_report_entity.dart';

class WorkReportModel extends WorkReportEntity {
  WorkReportModel({
    required super.id,
    required super.workOrderId,
    required super.companyId,
    required super.createdAt,
    super.startedAt,
    super.completedAt,
    super.reportForms,
  });

  factory WorkReportModel.fromJson(Map<String, dynamic> json) {
    // final submissions =
    //     safeParse<List<dynamic>?>(json, "submissions", requiredField: false)
    //         ?.map((sub) => SubmissionsModel.fromJson(sub))
    //         .toList();

    return WorkReportModel(
        id: safeParse<String>(json, "_id"),
        workOrderId: safeParse<String>(json, "workOrderId"),
        // workOrderId: safeParse<String>(json, "workOrder._id"),
        companyId: safeParse<String>(json, "companyId"),
        createdAt: DateTime.parse(safeParse<String>(json, "createdAt")),
        startedAt:
            safeParse<DateTime?>(json, "startedAt", requiredField: false),
        completedAt:
            safeParse<DateTime?>(json, "completedAt", requiredField: false),
        reportForms: null);
  }
}
