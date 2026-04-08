import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';

class FormRendererCoordinator {
  final FormEntity form;
  final SubmissionDraft draft;

  FormRendererCoordinator._({
    required this.form,
    required this.draft,
  });

  factory FormRendererCoordinator.filledForm(FilledFormEntity filledForm) {
    return FormRendererCoordinator._(
        form: filledForm.form,
        draft: filledForm.submission != null
            ? SubmissionDraft.fromEntity(filledForm.submission!)
            : SubmissionDraft.fromFormEntity(filledForm.form));
  }

  factory FormRendererCoordinator.form(FormEntity form) {
    return FormRendererCoordinator._(
        form: form, draft: SubmissionDraft.fromFormEntity(form));
  }

  void updateValue(String order, dynamic value) {
    draft.updateValue(order, value);
  }
}
