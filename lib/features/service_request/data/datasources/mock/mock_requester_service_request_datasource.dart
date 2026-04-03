import 'dart:async';

import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/requester_service_request_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/model/requester_service_request_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class MockRequesterServiceRequestDatasource
    implements RequesterServiceRequestDatasource {
  final List<RequesterServiceRequestModel> _storage = [
    RequesterServiceRequestModel(
      id: "req-1",
      code: "SR-001",
      status: ServiceRequestStatus.received,
      service: ServiceSummaryModel(
        isActive: true,
        id: "service-1",
        title: "Cleaning Service",
        description: "General cleaning",
        accessType: ServiceAccessType.public,
      ),
      requestedBy: UserModel(
        name: "John Doe",
        email: "john@example.com",
        role: UserRole.client,
      ),
      company: CompanyModel(
        id: "company-1",
        name: "Clean Corp",
        isActive: true,
      ),
      intakeForm: null,
      reviewForm: null,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  ApiFutureList<RequesterServiceRequestModel> getServiceRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));

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
  ApiFuture<FormModel> getIntakeForm(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final form = FormModel(
      id: "intake-$serviceId",
      title: "Intake Form",
      description: "Mock intake form",
      formType: FormType.intake,
      fields: const [],
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
      description: "Mock review form",
      formType: FormType.intake,
      fields: const [],
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
      return ApiResponse(
        message: "Service not found",
        data: null,
      );
    }

    final existing = _storage[index];

    final updated = RequesterServiceRequestModel(
      id: existing.id,
      code: existing.code,
      status: ServiceRequestStatus.received,
      service: existing.service,
      requestedBy: existing.requestedBy,
      company: existing.company,
      intakeForm: existing.intakeForm,
      reviewForm: existing.reviewForm,
      createdAt: existing.createdAt,
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

    final index = _storage.indexWhere((e) => e.id == serviceRequestId);

    if (index == -1) {
      return ApiResponse(
        message: "Service request not found",
        data: null,
      );
    }

    final existing = _storage[index];

    final updated = RequesterServiceRequestModel(
      id: existing.id,
      code: existing.code,
      status: ServiceRequestStatus.completed,
      service: existing.service,
      requestedBy: existing.requestedBy,
      company: existing.company,
      intakeForm: existing.intakeForm,
      reviewForm: existing.reviewForm,
      createdAt: existing.createdAt,
    );

    _storage[index] = updated;

    return ApiResponse(
      message: "Success submit review form",
      data: updated,
    );
  }

  @override
  ApiFuture<RequesterServiceRequestModel> cancelServiceRequest(
      String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _storage.indexWhere((e) => e.id == id);

    if (index == -1) {
      return ApiResponse(
        message: "Service request not found",
        data: null,
      );
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
      createdAt: existing.createdAt,
    );

    _storage[index] = updated;

    return ApiResponse(
      message: "Success cancel request",
      data: updated,
    );
  }
}
