import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/submission_entity.dart';

class FilledFormEntity {
  final FormEntity form;
  final SubmissionEntity? submission;

  const FilledFormEntity({
    required this.form,
    this.submission,
  });

  bool get hasSubmission => submission != null;
}
