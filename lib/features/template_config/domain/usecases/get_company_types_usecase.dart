import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/company_type_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/repositories/template_config_repository.dart';

class GetCompanyTypesUsecase {
  final TemplateConfigRepository _repository;

  GetCompanyTypesUsecase(this._repository);

  FutureEitherList<CompanyTypeEntity> call() {
    return _repository.getCompanyTypes();
  }
}
