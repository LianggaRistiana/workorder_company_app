import 'package:workorder_company_app/core/model/multipart_result.dart';
import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/services/cache/streamable_cache.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/pdf_faq_doc_draft.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';

abstract class FaqConfigRepository implements Cacheable, StreamableCache {
  FutureEither<CompanyEntity> toggleFaqFeature(bool value);
  FutureEitherList<FaqDocEntity> getFaqDocs({
    bool forceRefresh = false,
  });
  FutureEither<FaqDocEntity> uploadTextDocs(
    TextFaqDocDraft draft,
  );
  Stream<MultipartResult<FaqDocEntity>> uploadPdfDoc(PdfFaqDocDraft draft);
  FutureEither<Empty> deleteFaqDoc(FaqDocEntity doc);
}
