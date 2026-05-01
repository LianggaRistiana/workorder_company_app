import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/selected_service_template_draft.dart';
import 'package:workorder_company_app/features/template_config/domain/repositories/template_config_repository.dart';

class GenerateServiceByTemplatesUsecase {
  final TemplateConfigRepository _repository;

  GenerateServiceByTemplatesUsecase(this._repository);

  FutureEitherList<ServiceEntity> call(SelectedServiceTemplateDraft draft) {
    return _repository.generateServices(draft);
  }
}
