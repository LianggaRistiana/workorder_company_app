import 'package:workorder_company_app/core/constants/app_enums/service_enum.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/services/data/datasources/internal_services_management_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/mock/service_mock_factory.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';

class MockServiceRemoteDatasource
    implements InternalServicesManagementRemoteDatasource {
  final factory = ServiceMockFactory();
  final factorySummary = ServiceSummaryMockFactory();

  @override
  ApiFuture<ServiceModel> createService(ServiceModel service) async {
    appLogger.i(service);

    final isAuto = service.workOrderDraftingType == WorkOrderDraftingType.auto;

    final isManual =
        service.workOrderDraftingType == WorkOrderDraftingType.manual;

    if (isAuto) {
      final hasWorkOrderForm = service.workOrdersConfig.any(
        (e) => e.workOrderForm != null,
      );

      if (hasWorkOrderForm) {
        throw ValidationException(
          "Auto drafting tidak boleh memiliki work order form",
        );
      }

      final hasManualApproval = service.workOrdersConfig.any(
        (e) =>
            e.workOrderAprrovalAccessType != WorkOrderAprrovalAccess.auto ||
            e.workReportApprovalAccessType != WorkReportApprovalAccess.auto,
      );

      if (hasManualApproval) {
        throw ValidationException(
          "Auto drafting wajib menggunakan auto approval",
        );
      }

      final requestApprovalInvalid =
          service.serviceRequestConfig.serviceRequestApprovalAccessType !=
              ServiceRequestApprovalAccess.auto;

      if (requestApprovalInvalid) {
        throw ValidationException(
          "Service request approval wajib auto",
        );
      }
    }

    if (isManual) {
      final hasNullForm = service.workOrdersConfig.any(
        (e) => e.workOrderForm == null,
      );

      if (hasNullForm) {
        throw ValidationException(
          "Manual drafting wajib memiliki work order form",
        );
      }
    }

    return MockApiResponse.success(service);
  }

  @override
  ApiFuture<ServiceModel> getServiceById(String id) async {
    Future.delayed(Duration(seconds: 1));
    return MockApiResponse.success(factory.createModel());
  }

  @override
  ApiFutureList<ServiceSummaryModel> getServices() async {
    Future.delayed(Duration(seconds: 1));
    return MockApiResponse.success(factorySummary.createList(count: 10));
  }

  @override
  ApiFuture<ServiceModel> removeService(String serviceId) {
    throw UnimplementedError();
  }

  @override
  ApiFuture<ServiceModel> toggleActive(ServiceModel service) {
    throw UnimplementedError();
  }

  @override
  ApiFuture<ServiceModel> updateService(ServiceModel service) async {
    appLogger.i(service);

    final isAuto = service.workOrderDraftingType == WorkOrderDraftingType.auto;

    final isManual =
        service.workOrderDraftingType == WorkOrderDraftingType.manual;

    if (isAuto) {
      final hasWorkOrderForm = service.workOrdersConfig.any(
        (e) => e.workOrderForm != null,
      );

      if (hasWorkOrderForm) {
        throw ValidationException(
          "Auto drafting tidak boleh memiliki work order form",
        );
      }

      final hasManualApproval = service.workOrdersConfig.any(
        (e) =>
            e.workOrderAprrovalAccessType != WorkOrderAprrovalAccess.auto ||
            e.workReportApprovalAccessType != WorkReportApprovalAccess.auto,
      );

      if (hasManualApproval) {
        throw ValidationException(
          "Auto drafting wajib menggunakan auto approval",
        );
      }

      final requestApprovalInvalid =
          service.serviceRequestConfig.serviceRequestApprovalAccessType !=
              ServiceRequestApprovalAccess.auto;

      if (requestApprovalInvalid) {
        throw ValidationException(
          "Service request approval wajib auto",
        );
      }
    }

    if (isManual) {
      final hasNullForm = service.workOrdersConfig.any(
        (e) => e.workOrderForm == null,
      );

      if (hasNullForm) {
        throw ValidationException(
          "Manual drafting wajib memiliki work order form",
        );
      }
    }

    return MockApiResponse.success(service);
  }
}
