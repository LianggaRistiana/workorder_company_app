import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/template_config/data/datasources/template_config_remote_datasource.dart';
import 'package:workorder_company_app/features/template_config/data/model/selected_service_template_payload_model.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/company_type_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/selected_service_template_draft.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_preview_entity.dart';
import 'package:workorder_company_app/features/template_config/domain/repositories/template_config_repository.dart';

class TemplateConfigRepositoryImpl implements TemplateConfigRepository {
  final TemplateConfigRemoteDatasource _remoteDatasource;

  TemplateConfigRepositoryImpl(this._remoteDatasource);

  @override
  FutureEitherList<CompanyTypeEntity> getCompanyTypes() async {
    return safeCall(() async {
      final response = await _remoteDatasource.getCompanyTypes();
      return response.data;
    });
  }

  @override
  FutureEitherList<ServiceTemplateEntity> getServiceTemplates(
      String companyTypeId) async {
    return safeCall(() async {
      final response =
          await _remoteDatasource.getServiceTemplates(companyTypeId);
      return response.data;
    });
  }

  @override
  FutureEither<ServiceTemplatePreviewEntity> getServiceTemplatePreview(
      String serviceTemplateId) async {
    return safeCall(() async {
      final response =
          await _remoteDatasource.getServiceTemplatePreview(serviceTemplateId);
      return response.data;
    });
  }

  @override
  FutureEitherList<ServiceSummaryEntity> generateServices(
      SelectedServiceTemplateDraft draft) async {
    return safeCall(() async {
      final response = await _remoteDatasource.generateServices(
        SelectedServiceTemplatePayloadModel.fromEntity(draft),
      );
      return response.data;
    });
  }
}
