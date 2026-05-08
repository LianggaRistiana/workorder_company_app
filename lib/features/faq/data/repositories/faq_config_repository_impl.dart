import 'dart:async';

import 'package:workorder_company_app/core/model/multipart_result.dart';
import 'package:workorder_company_app/core/services/cache/list_cache_helper.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/either_helper.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_config_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/model/pdf_faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/text_faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/pdf_faq_doc_draft.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';

class FaqConfigRepositoryImpl implements FaqConfigRepository {
  final FaqConfigRemoteDatasource _remoteDatasource;

  final ListCacheHelper<FaqDocEntity> _cache = ListCacheHelper();
  final _refreshController = StreamController<void>.broadcast();

  @override
  Stream<void> get cacheChanged => _refreshController.stream;

  void _notifyChanged() {
    _refreshController.add(null);
  }

  FaqConfigRepositoryImpl(this._remoteDatasource);

  @override
  FutureEither<Empty> deleteFaqDoc(FaqDocEntity doc) async {
    final result = await safeCall(() async {
      final response = await _remoteDatasource.deleteFaqDoc(doc.id);
      return response.data;
    });

    return result.onSuccess((updated) {
      _cache.removeSingle(
        doc,
        (a, b) => a.id == b.id,
      );
      _notifyChanged();
    });
  }

  @override
  FutureEitherList<FaqDocEntity> getFaqDocs({
    bool forceRefresh = false,
  }) {
    return _cache.fetchList(
        remoteCall: () async {
          final response = await _remoteDatasource.getFaqDocs();
          return response.data;
        },
        forceRefresh: forceRefresh);
  }

  @override
  FutureEither<CompanyEntity> toggleFaqFeature(bool value) {
    return safeCall(() async {
      final response = await _remoteDatasource.toggleFaqFeature(value);
      return response.data;
    });
  }

  @override
  Stream<MultipartResult<FaqDocEntity>> uploadPdfDoc(PdfFaqDocDraft draft) {
    return _remoteDatasource
        .uploadPdfDoc(PdfFaqDocModel.fromDraft(draft))
        .map((result) {
      if (result.isDone) {
        final data = result.data;
        if (data != null) {
          _cache.mergeSingle(
            data,
            (a, b) => a.id == b.id,
          );
          _notifyChanged();
        }
      }
      return result;
    });
  }

  @override
  FutureEither<FaqDocEntity> uploadTextDocs(TextFaqDocDraft draft) async {
    final result = await safeCall(() async {
      final response = await _remoteDatasource
          .uploadTextDocs(TextFaqDocModel.fromDraft(draft));
      return response.data;
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
  void clearCache() {
    _cache.clear();
  }
}
