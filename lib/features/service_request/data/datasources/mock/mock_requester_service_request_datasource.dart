import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/forms/data/model/field_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/option_model.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/requester_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/model/requester_service_request_model.dart';
import 'package:workorder_company_app/features/service_request/data/model/service_request_status_date_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/field_data_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class MockRequesterServiceRequestDatasource
    implements RequesterServiceRequestRemoteDatasource {
  final List<RequesterServiceRequestModel> _storage = [
    RequesterServiceRequestModel(
      statusDate: ServiceRequestStatusDateModel(),
      id: "req-1",
      code: "SR-001",
      status: ServiceRequestStatus.received,
      service: const ServiceSummaryModel(
        isActive: true,
        id: "service-1",
        title: "Cleaning Service",
        description: "General cleaning for office spaces",
        accessType: ServiceAccessType.public,
      ),
      requestedBy: const UserModel(
        name: "John Doe",
        email: "hmti@client.com",
        role: UserRole.client,
      ),
      company: CompanyModel(
        id: "company-1",
        name: "Clean Corp",
        isActive: true,
        isFaqActive: true,
        address: "123 Clean St",
        description: "Best cleaning services in town",
      ),
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
      reviewForm: FilledFormModel(
        form: const FormModel(
          id: "review-req-1",
          title: "Review Form",
          description: "Please evaluate the work done",
          formType: FormType.report,
          fields: [
            FieldModel(
              order: 1,
              label: "Rating",
              type: FieldType.number,
              required: true,
              min: 1,
              max: 5,
            ),
            FieldModel(
              order: 2,
              label: "Comments",
              type: FieldType.textarea,
              required: false,
              placeholder: "Any additional feedback?",
            ),
            FieldModel(
              order: 3,
              label: "Priority",
              type: FieldType.singleSelect,
              required: true,
              options: [
                OptionModel(key: "high", value: "High"),
                OptionModel(key: "medium", value: "Medium"),
                OptionModel(key: "low", value: "Low"),
              ],
            ),
          ],
        ),
        submission: SubmissionsModel(
          id: "sub-2",
          formId: "review-req-1",
          submissionType: FormType.report,
          createdAt: DateTime.now(),
          fieldsData: [
            FieldDataModel(
              order: "1",
              value: "5",
            ),
            FieldDataModel(
              order: "2",
              value: "Great job so far preparing.",
            ),
            FieldDataModel(
              order: "3",
              value: "high",
            ),
          ],
        ),
      ),
    ),
  ];

  @override
  ApiFutureList<RequesterServiceRequestModel> getServiceRequests() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    return ApiResponse(
      message: "Success get service requests",
      data: _storage,
    );
  }

  @override
  ApiFuture<RequesterServiceRequestModel> getServiceRequestDetail(
      String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final item = _storage.firstWhere((e) => e.id == id);

    return ApiResponse(
      message: "Success get detail",
      data: item,
    );
  }

  @override
  ApiFuture<FormModel> getIntakeFormForPublic(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final form = FormModel(
      id: "intake-$serviceId",
      title: "Intake Form",
      description: "Please fill out the details of your request",
      formType: FormType.intake,
      fields: const [
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
    );

    return ApiResponse(
      message: "Success get intake form",
      data: form,
    );
  }

  @override
  ApiFuture<FormModel> getIntakeFormForInternal(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final form = FormModel(
      id: "intake-$serviceId",
      title: "Intake Form INTERNALLLL",
      description: "Please fill out the details of your request",
      formType: FormType.intake,
      fields: const [
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
    );

    return ApiResponse(
      message: "Success get intake form",
      data: form,
    );
  }

  @override
  ApiFuture<FormModel> getReviewForm(String serviceRequestId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final form = FormModel(
      id: "review-$serviceRequestId",
      title: "Review Form",
      description: "Please evaluate the work done",
      formType: FormType.report,
      fields: const [
        FieldModel(
          order: 1,
          label: "Rating",
          type: FieldType.number,
          required: true,
          min: 1,
          max: 5,
        ),
        FieldModel(
          order: 2,
          label: "Comments",
          type: FieldType.textarea,
          required: false,
          placeholder: "Any additional feedback?",
        ),
      ],
    );

    return ApiResponse(
      message: "Success get review form",
      data: form,
    );
  }

  @override
  ApiFuture<RequesterServiceRequestModel> submitIntakeForm(
      String serviceId, SubmissionsModel submission) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _storage.indexWhere((e) => e.service.id == serviceId);

    if (index == -1) {
      throw ApiException(404, "service not found");
    }

    final existing = _storage[index];

    final updated = RequesterServiceRequestModel(
      statusDate: ServiceRequestStatusDateModel(),
      id: existing.id,
      code: existing.code,
      status: ServiceRequestStatus.received,
      service: existing.service,
      requestedBy: existing.requestedBy,
      company: existing.company,
      intakeForm: existing.intakeForm != null
          ? FilledFormModel(
              form: existing.intakeForm!.form,
              submission: submission,
            )
          : null,
      reviewForm: existing.reviewForm,
    );

    _storage[index] = updated;

    return ApiResponse(
      message: "Success submit intake form",
      data: updated,
    );
  }

  @override
  ApiFuture<RequesterServiceRequestModel> submitReviewForm(
      String serviceRequestId, SubmissionsModel submission) async {
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint(submission.toString());

    final index = _storage.indexWhere((e) => e.id == serviceRequestId);

    if (index == -1) {
      throw ApiException(404, "Service request not found");
    }

    final existing = _storage[index];

    return ApiResponse(
      message: "Success submit review form",
      data: existing,
    );
  }

  @override
  ApiFuture<RequesterServiceRequestModel> cancelServiceRequest(
      String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _storage.indexWhere((e) => e.id == id);

    if (index == -1) {
      throw ApiException(404, "Service request not found");
    }

    final existing = _storage[index];

    final updated = RequesterServiceRequestModel(
      id: existing.id,
      code: existing.code,
      status: ServiceRequestStatus.cancelled,
      service: existing.service,
      requestedBy: existing.requestedBy,
      company: existing.company,
      intakeForm: existing.intakeForm,
      reviewForm: existing.reviewForm,
      statusDate: ServiceRequestStatusDateModel(),
    );

    _storage[index] = updated;

    return ApiResponse(
      message: "Success cancel request",
      data: updated,
    );
  }
}
