import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_config_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/model/text_faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';

class FaqConfigRepositoryImpl implements FaqConfigRepository {
  final FaqConfigRemoteDatasource _remoteDatasource;

  FaqConfigRepositoryImpl(this._remoteDatasource);

  // TODO : add cache here

  @override
  FutureEither<Empty> deleteFaqDoc(String id) async {
    return safeCall(() async {
      final response = await _remoteDatasource.deleteFaqDoc(id);
      return response.data;
    });
  }

  @override
  FutureEitherList<FaqDocEntity> getFaqDocs() {
    return safeCall(() async {
      final response = await _remoteDatasource.getFaqDocs();
      return response.data;
    });
  }

  @override
  FutureEither<CompanyEntity> toggleFaqFeature(bool value) {
    return safeCall(() async {
      final response = await _remoteDatasource.toggleFaqFeature(value);
      return response.data;
    });
  }

  @override
  Stream<UploadResult> uploadPdfDoc(String filePath) {
    // TODO : add listen here, when success update the cache
    return _remoteDatasource.uploadPdfDoc(filePath);
  }

  @override
  FutureEither<FaqDocEntity> uploadTextDocs(TextFaqDocDraft draft) {
    return safeCall(() async {
      final response = await _remoteDatasource
          .uploadTextDocs(TextFaqDocModel.fromDraft(draft));
      return response.data;
    });
  }
}
