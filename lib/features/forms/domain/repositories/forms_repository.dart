import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

abstract class FormsRepository {
  FutureEitherList<FormEntity> getForms({bool forceRefresh = false});
  FutureEither<FormEntity> getForm(String id);
  FutureEither<void> createForm(FormEntity form);
  FutureEither<FormEntity> updateForm(FormEntity form);
  // TODO[High] : add delete form
}
