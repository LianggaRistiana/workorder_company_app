import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class FilledFormWithHistoryModel extends FilledFormWithHistoryEntity {
  const FilledFormWithHistoryModel({
    required super.form,
    super.submissionHistory,
  });

  factory FilledFormWithHistoryModel.fromJson(
    Map<String, dynamic> formJson,
    dynamic submissionsJson,
  ) {
    List<SubmissionsModel>? submissions;

    if (submissionsJson != null) {
      if (submissionsJson is! List) {
        throw ParsingException(
          "Field 'submissions' expected List but got ${submissionsJson.runtimeType}",
        );
      }

      submissions = submissionsJson.map((e) {
        if (e is! Map<String, dynamic>) {
          throw ParsingException(
            "Each submission must be Map<String, dynamic> but got ${e.runtimeType}",
          );
        }
        return SubmissionsModel.fromJson(e);
      }).toList()
        ..sort((a, b) {
          final aDate = a.createdAt;
          final bDate = b.createdAt;

          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;

          return bDate.compareTo(aDate);
        });
    }

    return FilledFormWithHistoryModel(
      form: FormModel.fromJson(formJson),
      submissionHistory: submissions,
    );
  }
}
