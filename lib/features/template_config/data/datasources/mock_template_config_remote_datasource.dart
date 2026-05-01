import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/template_config/data/datasources/template_config_remote_datasource.dart';
import 'package:workorder_company_app/features/template_config/data/model/company_type_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/selected_service_template_payload_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/service_template_model.dart';
import 'package:workorder_company_app/features/template_config/data/model/service_template_preview_model.dart';

class MockTemplateConfigRemoteDatasourceImpl implements TemplateConfigRemoteDatasource {
  bool shouldThrowError = false;

  Map<String, dynamic> get _dummyOptionJson => {
        'key': 'opt-1',
        'value': 'Option 1',
      };

  Map<String, dynamic> get _dummyFieldJson => {
        'order': 1,
        'label': 'Dummy Field Label',
        'type': 'text',
        'required': true,
        'placeholder': 'Enter value...',
        'min': 0,
        'max': 100,
        'options': [_dummyOptionJson],
      };

  Map<String, dynamic> get _dummyFormJson => {
        '_id': 'form-1',
        'title': 'Dummy Form',
        'formType': 'intake',
        'description': 'This is a fully generated dummy form.',
        'fields': [_dummyFieldJson],
      };

  Map<String, dynamic> get _dummyPositionJson => {
        '_id': 'pos-1',
        'name': 'Dummy Position',
        'description': 'Dummy Position Description',
        'isActive': true,
      };

  Map<String, dynamic> get _dummyServiceJson => {
        '_id': 'srv-1',
        'title': 'Mocked Service',
        'description': 'Description of fully generated service',
        'accessType': 'public',
        'isActive': true,
        'serviceRequestConfig': {
          'intakeForm': _dummyFormJson,
          'reviewForm': _dummyFormJson,
          'serviceRequestApprovalAccessType': 'auto',
          'reviewNeed': false,
        },
        'workOrdersConfig': [
          {
            'workOrderForm': _dummyFormJson,
            'workReportForm': _dummyFormJson,
            'positionsOnDuty': _dummyPositionJson,
            'workOrderApprovalAccessType': 'auto',
            'workReportApprovalAccessType': 'auto',
            'minStaff': 1,
            'maxStaff': 5,
          }
        ],
      };

  @override
  ApiFutureList<CompanyTypeModel> getCompanyTypes() async {
    await Future.delayed(const Duration(seconds: 1));
    if (shouldThrowError) {
      throw ApiException(500, 'Mock Error fetching company types');
    }

    return const ApiResponse(
      message: 'Success',
      data: [
        CompanyTypeModel(id: '1', name: 'Software House'),
        CompanyTypeModel(id: '2', name: 'Hospitality'),
        CompanyTypeModel(id: '3', name: 'Manufacturing'),
      ],
    );
  }

  @override
  ApiFutureList<ServiceTemplateModel> getServiceTemplates(String companyTypeId) async {
    await Future.delayed(const Duration(seconds: 1));
    if (shouldThrowError) {
      throw ApiException(500, 'Mock Error fetching service templates');
    }

    return const ApiResponse(
      message: 'Success',
      data: [
        ServiceTemplateModel(
          id: 'tpl-1',
          title: 'IT Support',
          desc: 'General IT support for software house.',
        ),
        ServiceTemplateModel(
          id: 'tpl-2',
          title: 'Network Maintenance',
          desc: 'Network maintenance and setup.',
        ),
      ],
    );
  }

  @override
  ApiFuture<ServiceTemplatePreviewModel> getServiceTemplatePreview(String serviceTemplateId) async {
    await Future.delayed(const Duration(seconds: 1));
    if (shouldThrowError) {
      throw ApiException(500, 'Mock Error fetching service template preview');
    }

    return ApiResponse(
      message: 'Success',
      data: ServiceTemplatePreviewModel.fromJson({
        '_id': 'preview-1',
        'service': _dummyServiceJson,
        'positionsRequired': [_dummyPositionJson]
      }),
    );
  }

  @override
  ApiFutureList<ServiceModel> generateServices(SelectedServiceTemplatePayloadModel payload) async {
    await Future.delayed(const Duration(seconds: 1));
    if (shouldThrowError) {
      throw ApiException(500, 'Mock Error generating services');
    }

    return ApiResponse(
      message: 'Success',
      data: [
        ServiceModel.fromJson(_dummyServiceJson)
      ],
    );
  }
}
