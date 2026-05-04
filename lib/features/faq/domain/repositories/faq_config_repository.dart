import 'package:workorder_company_app/core/model/multipart_result.dart';
import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';

// TODO : add streamable here
abstract class FaqConfigRepository implements Cacheable {
  FutureEither<CompanyEntity> toggleFaqFeature(bool value);
  FutureEitherList<FaqDocEntity> getFaqDocs({
    bool forceRefresh = false,
  });
  FutureEither<FaqDocEntity> uploadTextDocs(
    TextFaqDocDraft draft,
  );
  Stream<MultipartResult<FaqDocEntity>> uploadPdfDoc(String filePath);
  FutureEither<Empty> deleteFaqDoc(String id);
}
