import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

abstract class FormsRepository implements Cacheable {
  FutureEitherList<FormEntity> getForms({bool forceRefresh = false});
  FutureEither<FormEntity> getForm(String id);
  FutureEither<void> createForm(FormEntity form);
  FutureEither<FormEntity> updateForm(FormEntity form);
  // TODO[High] : consider add delete form or not
}
