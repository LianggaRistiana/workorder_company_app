import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';


// TODO : rename this add 'doc' to clarity reason
class DeleteFaqUsecase {
  final FaqConfigRepository repository;

  DeleteFaqUsecase(this.repository);

  FutureEither<void> call(String id) async {
    return await repository.deleteFaqDoc(id);
  }
}
