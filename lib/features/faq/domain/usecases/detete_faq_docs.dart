import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';

class DeleteFaqDocUsecase {
  final FaqConfigRepository repository;

  DeleteFaqDocUsecase(this.repository);

  FutureEither<void> call(FaqDocEntity doc) async {
    return await repository.deleteFaqDoc(doc);
  }
}
