import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/has_form.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class FilledFormEntity implements HasForm {
  @override
  final FormEntity form;
  final SubmissionEntity? submission;

  const FilledFormEntity({
    required this.form,
    required this.submission,
  });
}
