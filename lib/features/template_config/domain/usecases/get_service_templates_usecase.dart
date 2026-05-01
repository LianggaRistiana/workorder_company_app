import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/repositories/template_config_repository.dart';

class GetServiceTemplatesUsecase {
  final TemplateConfigRepository _repository;

  GetServiceTemplatesUsecase(this._repository);

  FutureEitherList<ServiceTemplateEntity> call(String companyTypeId) {
    return _repository.getServiceTemplates(companyTypeId);
  }
}
