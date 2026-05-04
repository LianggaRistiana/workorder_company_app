import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';

class ToggleActiveFaqUsecase {
  final FaqConfigRepository repository;

  ToggleActiveFaqUsecase(this.repository);

  FutureEither<CompanyEntity> call(bool isActive) async {
    return await repository.toggleFaqFeature(isActive);
  }
}
