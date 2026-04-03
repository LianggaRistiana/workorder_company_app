import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/ordered_form_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/workreport/domain/entitties/work_report_entity.dart';

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
    final orderedForms =
        safeParse<List<dynamic>?>(json, "reportForms", requiredField: false)
            ?.map((form) => OrderedFormModel.fromJson(form))
            .toList();

    // final submissions =
    //     safeParse<List<dynamic>?>(json, "submissions", requiredField: false)
    //         ?.map((sub) => SubmissionsModel.fromJson(sub))
    //         .toList();

    final submissions =
        safeParse<List<dynamic>?>(json, "submissions", requiredField: false)
            ?.map((sub) => SubmissionsModel.fromJson(sub))
            .toList()
          ?..sort((a, b) {
            final aDate = a.createdAt;
            final bDate = b.createdAt;

            // null dianggap paling lama → taruh di bawah
            if (aDate == null && bDate == null) return 0;
            if (aDate == null) return 1;
            if (bDate == null) return -1;

            // DESC: paling baru dulu
            return bDate.compareTo(aDate);
          });

    final filledForms = orderedForms?.map((form) {
      final matchedSubmission =
          submissions?.where((sub) => sub.formId == form.form.id).firstOrNull;

      return FilledFormModel(
        // order: form.order,
        form: form.form,
        submission: matchedSubmission,
      );
    }).toList();

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
        reportForms: filledForms);
  }
}
