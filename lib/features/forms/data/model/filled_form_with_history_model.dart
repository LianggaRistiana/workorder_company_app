import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class FilledFormWithHistoryModel extends FilledFormWithHistoryEntity {
  const FilledFormWithHistoryModel({
    required super.form,
    super.submissionHistory,
  });

  factory FilledFormWithHistoryModel.fromJson(
      Map<String, dynamic> formJson, Map<String, dynamic> submissionsJson) {
    final submissions = safeParse<List<dynamic>?>(
            submissionsJson, "submissions",
            requiredField: false)
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

    return FilledFormWithHistoryModel(
      form: FormModel.fromJson(formJson),
      submissionHistory: submissions,
    );
  }

  FilledFormWithHistoryEntity toEntity() {
    return FilledFormWithHistoryEntity(
      form: form,
      submissionHistory: submissionHistory,
    );
  }
}
