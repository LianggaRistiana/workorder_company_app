import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/has_form.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class FilledFormWithHistoryEntity implements HasForm {
  @override
  final FormEntity form;
  final List<SubmissionEntity>? submissionHistory;

  const FilledFormWithHistoryEntity({
    required this.form,
    this.submissionHistory,
  });

  FilledFormWithHistoryEntity copyWith({
    FormEntity? form,
    List<SubmissionEntity>? submissionHistory,
  }) {
    return FilledFormWithHistoryEntity(
      form: form ?? this.form,
      submissionHistory: submissionHistory ?? this.submissionHistory,
    );
  }
}

extension FilledFormWithHistoryEntityTools on FilledFormWithHistoryEntity {
  List<SubmissionEntity> get history =>
      List.unmodifiable(submissionHistory ?? []);

  bool get hasSubmission => history.isNotEmpty;

  SubmissionEntity? get latestSubmission =>
      hasSubmission ? history.first : null;

  SubmissionEntity? getSubmissionById(String id) {
    try {
      return history.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<SubmissionEntity> get historyDescending {
    final list = [...history];
    list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return list;
  }

  FilledFormEntity get currentFilledForm => FilledFormEntity(
        form: form,
        submission: latestSubmission,
      );
}
