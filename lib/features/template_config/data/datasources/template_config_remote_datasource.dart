import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/template_config/data/model/company_type_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/selected_service_template_payload_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/service_template_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/service_template_preview_model.dart';

abstract class TemplateConfigRemoteDatasource {
  ApiFutureList<CompanyTypeModel> getCompanyTypes();
  ApiFutureList<ServiceTemplateModel> getServiceTemplates(String companyTypeId);
  ApiFuture<ServiceTemplatePreviewModel> getServiceTemplatePreview(
      String serviceTemplateId);
  ApiFutureList<ServiceEntity> generateServices(
    SelectedServiceTemplatePayloadModel payload,
  );
}
