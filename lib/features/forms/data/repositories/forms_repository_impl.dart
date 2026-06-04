import 'dart:async';

import 'package:workorder_company_app/core/services/cache/list_cache_helper.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/either_helper.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/meta/form_detail_meta.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class FormsRepositoryImpl implements FormsRepository {
  final FormsRemoteDatasource _remoteDatasource;

  final ListCacheHelper<FormEntity> _cache = ListCacheHelper();

  final _refreshController = StreamController<void>.broadcast();

  @override
  Stream<void> get cacheChanged => _refreshController.stream;

  void _notifyChanged() {
    _refreshController.add(null);
  }

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
  FutureEitherWithMeta<FormEntity> getForm(String id) {
    return safeCall(() async {
      final payload = await _remoteDatasource.getFormById(id);
      return payload.toResultSingleMeta(metaFactory: FormDetailMeta.fromJson);
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
      _notifyChanged();
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
      _notifyChanged();
    });
  }

  @override
  void clearCache() {
    _cache.clear();
  }

  @override
  FutureEither<Empty> deleteForm(FormEntity form) async {
    final result = await safeCall(() async {
      final formModel = FormModel.fromEntity(form);
      final payload = await _remoteDatasource.deleteForm(formModel);
      return payload.data;
    });

    return result.onSuccess((_) {
      _cache.removeSingle(
        form,
        (a, b) => a.id == b.id,
      );
      _notifyChanged();
    });
  }
}
