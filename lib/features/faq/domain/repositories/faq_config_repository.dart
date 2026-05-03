import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';

abstract class FaqConfigRepository {
  FutureEither<CompanyEntity> toggleFaqFeature(bool value);
  FutureEitherList<FaqDocEntity> getFaqDocs();
  FutureEither<FaqDocEntity> uploadTextDocs(
    TextFaqDocDraft draft,
  );
  Stream<UploadResult> uploadPdfDoc(String filePath);
  FutureEither<Empty> deleteFaqDoc(String id);
}
