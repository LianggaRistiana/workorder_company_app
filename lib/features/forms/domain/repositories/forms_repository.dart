import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/services/cache/streamable_cache.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

abstract class FormsRepository implements Cacheable, StreamableCache {
  FutureEitherList<FormEntity> getForms({bool forceRefresh = false});
  FutureEitherWithMeta<FormEntity> getForm(String id);
  FutureEither<void> createForm(
      FormEntity form); // OPTIMIZE : Better to return Empty instead of void
  FutureEither<FormEntity> updateForm(FormEntity form);
  FutureEither<Empty> deleteForm(FormEntity form);
}
