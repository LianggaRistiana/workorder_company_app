import 'package:workorder_company_app/core/services/cache/list_cache_helper.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/either_helper.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class FormsRepositoryImpl implements FormsRepository {
  final FormsRemoteDatasource _remoteDatasource;

  final ListCacheHelper<FormEntity> _cache = ListCacheHelper();

  FormsRepositoryImpl(this._remoteDatasource);

  @override
  FutureEitherList<FormEntity> getForms({bool forceRefresh = false}) {
    return _cache.fetchList(
        remoteCall: () async {
          final forms = await _remoteDatasource.getForms();
          return forms.data;
        },
        forceRefresh: forceRefresh);
  }

  @override
  FutureEither<FormEntity> getForm(String id) {
    return safeCall(() async {
      final form = await _remoteDatasource.getFormById(id);
      return form.data;
    });
  }

  @override
  FutureEither<void> createForm(FormEntity form) async {
    final result = await safeCall(() async {
      final formModel = FormModel.fromEntity(form);
      final payload = await _remoteDatasource.createForm(formModel);
      return payload.data;
    });

    return result.onSuccess((updated) {
      _cache.mergeSingle(
        updated,
        (a, b) => a.id == b.id,
      );
    });
  }

  @override
  FutureEither<FormEntity> updateForm(FormEntity form) async {
    final result = await safeCall(() async {
      final formModel = FormModel.fromEntity(form);
      final payload = await _remoteDatasource.updateForm(formModel);
      return payload.data;
    });

    return result.onSuccess((updated) {
      _cache.removeSingle(
        form,
        (a, b) => a.id == b.id,
      );
      _cache.mergeSingle(
        updated,
        (a, b) => a.id == b.id,
      );
    });
  }
  
  @override
  void clearCache() {
    _cache.clear();
  }
}
