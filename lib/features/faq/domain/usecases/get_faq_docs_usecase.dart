import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';

class GetFaqDocsUsecase {
  final FaqConfigRepository repository;

  GetFaqDocsUsecase(this.repository);

  FutureEitherList<FaqDocEntity> call({
    bool forceRefresh = false,
  }) async {
    return await repository.getFaqDocs(
      forceRefresh: forceRefresh,
    );
  }
}
