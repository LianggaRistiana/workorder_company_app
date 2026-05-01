import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_preview_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/repositories/template_config_repository.dart';

class GetServicePreviewUsecase {
  final TemplateConfigRepository _repository;

  GetServicePreviewUsecase(this._repository);

  FutureEither<ServiceTemplatePreviewEntity> call(String serviceTemplateId) {
    return _repository.getServiceTemplatePreview(serviceTemplateId);
  }
}
