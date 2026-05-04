import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';

class DeleteFaqUsecase {
  final FaqConfigRepository repository;

  DeleteFaqUsecase(this.repository);

  FutureEither<void> call(String id) async {
    return await repository.deleteFaqDoc(id);
  }
}
