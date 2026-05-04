import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/text_faq_doc_draft.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';

class UploadTextFaqUsecase {
  final FaqConfigRepository repository;

  UploadTextFaqUsecase(this.repository);

  FutureEither<FaqDocEntity> call(TextFaqDocDraft draft) async {
    return await repository.uploadTextDocs(draft);
  }
}
