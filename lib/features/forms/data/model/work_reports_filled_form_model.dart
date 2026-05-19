import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/work_reports_filled_form_entity.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class WorkReportsFilledFormModel extends WorkReportsFilledFormEntity {
  const WorkReportsFilledFormModel({
    required super.filledForms,
  });

  factory WorkReportsFilledFormModel.fromJson(Map<String, dynamic> json) {
    final forms =
        json.field("workReportForms").reqListModel(FormModel.fromJson);

    final submissions = json
        .field("submissions")
        .optListModel(SubmissionsModel.fromJson) // FIXME : fix this responses
      ?..sort((a, b) {
        final aDate = a.createdAt;
        final bDate = b.createdAt;
        return bDate.compareTo(aDate);
      });

    final filledForms = forms.map((form) {
      final submission = submissions
          ?.where(
            (element) => element.formId == form.id,
          )
          .firstOrNull;

      return FilledFormModel(
        form: form,
        submission: submission,
      );
    }).toList();

    return WorkReportsFilledFormModel(
      filledForms: filledForms,
    );
  }
}
