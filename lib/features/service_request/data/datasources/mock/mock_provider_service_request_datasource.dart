import 'dart:async';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/forms/data/model/field_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/option_model.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/provider_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/model/provider_service_request_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/field_data_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class MockProviderServiceRequestDatasource
    implements ProviderServiceRequestRemoteDatasource {
  final List<ProviderServiceRequestModel> _storage = [
    ProviderServiceRequestModel(
      id: "req-1",
      code: "SR-001",
      status: ServiceRequestStatus.received,
      service: const ServiceSummaryModel(
        isActive: true,
        id: "service-1",
        title: "Cleaning Service haiii",
        description: "General cleaning for office spaces",
        accessType: ServiceAccessType.public,
      ),
      requestedBy: const UserModel(
        name: "John Doe",
        email: "hmti@client.com",
        role: UserRole.client,
      ),
      reviewNeed: true,
      approvalAccess: ServiceRequestApprovalAccess.manager,
      intakeForm: FilledFormModel(
        form: const FormModel(
          id: "intake-service-1",
          title: "Intake Form",
          description: "Please fill out the details of your request",
          formType: FormType.intake,
          fields: [
            FieldModel(
              order: 1,
              label: "Problem Description",
              type: FieldType.textarea,
              required: true,
              placeholder: "Describe the issue...",
            ),
            FieldModel(
              order: 2,
              label: "Priority",
              type: FieldType.singleSelect,
              required: true,
              options: [
                OptionModel(key: "high", value: "High"),
                OptionModel(key: "medium", value: "Medium"),
                OptionModel(key: "low", value: "Low"),
              ],
            ),
            FieldModel(
              order: 3,
              label: "Preferred Date",
              type: FieldType.date,
              required: false,
            ),
          ],
        ),
        submission: SubmissionsModel(
          id: "sub-1",
          formId: "intake-service-1",
          submissionType: FormType.intake,
          submittedBy: const UserModel(
            name: "John Doe",
            email: "hmti@client.com",
            role: UserRole.client,
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          fieldsData: [
            FieldDataModel(
              order: "1",
              value: "The hall needs a deep clean, lots of dust.",
            ),
            FieldDataModel(
              order: "2",
              value: "high",
            ),
            FieldDataModel(
              order: "3",
              value: DateTime.now(),
            ),
          ],
        ),
      ),
      reviewForm: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  ApiFutureList<ProviderServiceRequestModel> getServiceRequests() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    return ApiResponse(
      message: "Success get service requests",
      data: _storage,
    );
  }

  @override
  ApiFuture<ProviderServiceRequestModel> getServiceRequestDetail(
      String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final item = _storage.firstWhere((e) => e.id == id);

    return ApiResponse(
      message: "Success get detail",
      data: item,
    );
  }

  @override
  ApiFuture<ProviderServiceRequestModel> approveServiceRequest(
      String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _storage.indexWhere((e) => e.id == id);

    if (index == -1) {
      throw ApiException(404, "Not found");
    }

    final existing = _storage[index];

    final updated = ProviderServiceRequestModel(
      id: existing.id,
      code: existing.code,
      status: ServiceRequestStatus.approved,
      service: existing.service,
      requestedBy: existing.requestedBy,
      reviewNeed: existing.reviewNeed,
      approvalAccess: existing.approvalAccess,
      intakeForm: existing.intakeForm,
      reviewForm: existing.reviewForm,
      createdAt: existing.createdAt,
    );

    _storage[index] = updated;

    return ApiResponse(
      message: "Success approve request",
      data: updated,
    );
  }

  @override
  ApiFuture<ProviderServiceRequestModel> rejectServiceRequest(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _storage.indexWhere((e) => e.id == id);

    if (index == -1) {
      throw ApiException(404, "Not found");
    }

    final existing = _storage[index];

    final updated = ProviderServiceRequestModel(
      id: existing.id,
      code: existing.code,
      status: ServiceRequestStatus.rejected,
      service: existing.service,
      requestedBy: existing.requestedBy,
      reviewNeed: existing.reviewNeed,
      approvalAccess: existing.approvalAccess,
      intakeForm: existing.intakeForm,
      reviewForm: existing.reviewForm,
      createdAt: existing.createdAt,
    );

    _storage[index] = updated;

    return ApiResponse(
      message: "Success reject request",
      data: updated,
    );
  }
}
