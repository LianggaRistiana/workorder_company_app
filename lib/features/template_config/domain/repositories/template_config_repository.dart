import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/company_type_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/selected_service_template_draft.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_preview_entity.dart';

abstract class TemplateConfigRepository {
  FutureEitherList<CompanyTypeEntity> getCompanyTypes();
  FutureEitherList<ServiceTemplateEntity> getServiceTemplates(
      String companyTypeId);
  FutureEither<ServiceTemplatePreviewEntity> getServiceTemplatePreview(
      String serviceTemplateId);
  FutureEitherList<ServiceSummaryEntity> generateServices(
    SelectedServiceTemplateDraft draft,
  );
}
