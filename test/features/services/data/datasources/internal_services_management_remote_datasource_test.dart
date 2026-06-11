import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services/data/datasources/internal_services_management_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_request_config_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/services/data/model/work_order_config_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late InternalServicesManagementRemoteDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = InternalServicesManagementRemoteDatasourceImpl(mockApiClient);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  FormModel makeFormModel({String id = 'form-123'}) {
    return FormModel(
      id: id,
      title: 'Form Title',
      formType: FormType.workOrder,
      description: 'Test description',
      position: null,
      fields: const [],
    );
  }

  PositionModel makePositionModel() {
    return const PositionModel(
      id: 'pos-123',
      name: 'Tech',
      description: 'Test position',
      isActive: true,
    );
  }

  ServiceModel makeServiceModel({String id = 'srv-123', bool isActive = true}) {
    return ServiceModel(
      id: id,
      title: 'Plumbing',
      description: 'Plumbing service',
      accessType: ServiceAccessType.public,
      isActive: isActive,
      serviceRequestConfig: ServiceRequestConfigModel(
        intakeForm: makeFormModel(id: 'f-intake'),
        reviewForm: makeFormModel(id: 'f-review'),
        serviceRequestApprovalAccessType: ServiceRequestApprovalAccess.manager,
        reviewNeed: true,
      ),
      workOrdersConfig: [
        WorkOrderConfigModel(
          workOrderForm: makeFormModel(id: 'f-wo'),
          workReportForm: makeFormModel(id: 'f-wr'),
          positionOnDuty: makePositionModel(),
          workOrderAprrovalAccessType: WorkOrderAprrovalAccess.staffPic,
          workReportApprovalAccessType: WorkReportApprovalAccess.manager,
          minStaff: 1,
          maxStaff: 3,
          showReportToRequester: true,
        ),
      ],
      workOrderDraftingType: WorkOrderDraftingType.manual,
      price: 200000,
    );
  }

  Map<String, dynamic> formJson({String id = 'form-123'}) => {
        '_id': id,
        'title': 'Form Title',
        'formType': 'work_order',
        'description': 'Test description',
        'position': null,
        'fields': const <dynamic>[],
      };

  Map<String, dynamic> positionJson() => {
        '_id': 'pos-123',
        'name': 'Tech',
        'description': 'Test position',
        'isActive': true,
      };

  Map<String, dynamic> serviceJson({String id = 'srv-123', bool isActive = true}) => {
        '_id': id,
        'title': 'Plumbing',
        'description': 'Plumbing service',
        'accessType': 'public',
        'isActive': isActive,
        'serviceRequestConfig': {
          'intakeForm': formJson(id: 'f-intake'),
          'reviewForm': formJson(id: 'f-review'),
          'serviceRequestApprovalAccessType': 'manager',
          'reviewNeed': true,
        },
        'draftingWorkOrderType': 'manual',
        'workOrdersConfig': [
          {
            'workOrderForm': formJson(id: 'f-wo'),
            'workReportForm': formJson(id: 'f-wr'),
            'positionsOnDuty': positionJson(),
            'workOrderApprovalAccessType': 'staff_pic',
            'workReportApprovalAccessType': 'manager',
            'minStaff': 1,
            'maxStaff': 3,
            'showReportToRequester': true,
          }
        ],
        'price': 200000,
      };

  Map<String, dynamic> summaryJson({String id = 'srv-123'}) => {
        '_id': id,
        'title': 'Plumbing',
        'description': 'Plumbing service',
        'accessType': 'public',
        'isActive': true,
        'price': 200000,
      };

  Map<String, dynamic> singleResponseJson({String id = 'srv-123', bool isActive = true}) => {
        'message': 'success',
        'data': serviceJson(id: id, isActive: isActive),
      };

  Map<String, dynamic> listResponseJson() => {
        'message': 'success',
        'data': [summaryJson()],
      };

  // ═══════════════════════════════════════════════════════════════════════
  // createService  │  Cyclomatic Complexity = 1
  //                │  Paths: success returns ApiResponse<ServiceModel>, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('createService —', () {
    final serviceModel = makeServiceModel();

    /// R4: returns ApiResponse<ServiceModel> on success.
    test('R4: returns ApiResponse<ServiceModel> on success', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.createService(serviceModel);

      // assert
      expect(result.data, isA<ServiceModel>());
      expect(result.data.id, 'srv-123');
    });

    /// R5: propagates ApiException when API client fails.
    test('R5: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.createService(serviceModel),
        throwsA(isA<ApiException>()),
      );
    });

    /// R6: calls post with correct endpoint and payload.
    test('R6: calls post with correct endpoint and payload', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.createService(serviceModel);

      // assert
      verify(() => mockApiClient.post<dynamic>(
            Endpoints.services,
            data: serviceModel.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServiceById  │  Cyclomatic Complexity = 1
  //                 │  Paths: success returns ApiResponse<ServiceModel>, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceById —', () {
    const id = 'srv-123';

    /// R7: returns ApiResponse<ServiceModel> on success.
    test('R7: returns ApiResponse<ServiceModel> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.getServiceById(id);

      // assert
      expect(result.data, isA<ServiceModel>());
      expect(result.data.id, id);
    });

    /// R8: propagates ApiException when API client fails.
    test('R8: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      // act & assert
      await expectLater(
        () async => datasource.getServiceById(id),
        throwsA(isA<ApiException>()),
      );
    });

    /// R9: calls get with correct endpoint.
    test('R9: calls get with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.getServiceById(id);

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.services.byId(id),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServices  │  Cyclomatic Complexity = 1
  //              │  Paths: success returns ApiResponse<List<ServiceSummaryModel>>, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getServices —', () {
    /// R10: returns ApiResponse<List<ServiceSummaryModel>> on success.
    test('R10: returns ApiResponse<List<ServiceSummaryModel>> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      // act
      final result = await datasource.getServices();

      // assert
      expect(result.data, isA<List<ServiceSummaryModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'srv-123');
    });

    /// R11: propagates ApiException when API client fails.
    test('R11: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Server Error'));

      // act & assert
      await expectLater(
        () async => datasource.getServices(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R12: calls get with correct endpoint.
    test('R12: calls get with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      // act
      await datasource.getServices();

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.services,
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updateService  │  Cyclomatic Complexity = 1
  //                │  Paths: success returns ApiResponse<ServiceModel>, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('updateService —', () {
    final serviceModel = makeServiceModel();

    /// R13: returns ApiResponse<ServiceModel> on success.
    test('R13: returns ApiResponse<ServiceModel> on success', () async {
      // arrange
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.updateService(serviceModel);

      // assert
      expect(result.data, isA<ServiceModel>());
      expect(result.data.id, 'srv-123');
    });

    /// R14: propagates ApiException when API client fails.
    test('R14: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.updateService(serviceModel),
        throwsA(isA<ApiException>()),
      );
    });

    /// R15: calls put with correct endpoint and payload.
    test('R15: calls put with correct endpoint and payload', () async {
      // arrange
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.updateService(serviceModel);

      // assert
      verify(() => mockApiClient.put<dynamic>(
            Endpoints.services.byId(serviceModel.id),
            data: serviceModel.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // removeService  │  Cyclomatic Complexity = 1
  //                │  Paths: success returns ApiResponse<ServiceModel>, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('removeService —', () {
    const id = 'srv-123';

    /// R16: returns ApiResponse<ServiceModel> on success.
    test('R16: returns ApiResponse<ServiceModel> on success', () async {
      // arrange
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.removeService(id);

      // assert
      expect(result.data, isA<ServiceModel>());
      expect(result.data.id, id);
    });

    /// R17: propagates ApiException when API client fails.
    test('R17: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenThrow(ApiException(400, 'Cannot delete'));

      // act & assert
      await expectLater(
        () async => datasource.removeService(id),
        throwsA(isA<ApiException>()),
      );
    });

    /// R18: calls delete with correct endpoint.
    test('R18: calls delete with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.removeService(id);

      // assert
      verify(() => mockApiClient.delete<dynamic>(
            Endpoints.services.byId(id),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // toggleActive  │  Cyclomatic Complexity = 1
  //               │  Paths: success returns ApiResponse<ServiceModel>, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('toggleActive —', () {
    final activeService = makeServiceModel(id: 'srv-123', isActive: true);
    final inactiveService = makeServiceModel(id: 'srv-123', isActive: false);

    /// R19: returns ApiResponse<ServiceModel> on success.
    test('R19: returns ApiResponse<ServiceModel> on success', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.toggleActive(activeService);

      // assert
      expect(result.data, isA<ServiceModel>());
      expect(result.data.id, 'srv-123');
    });

    /// R20: propagates ApiException when API client fails.
    test('R20: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.toggleActive(activeService),
        throwsA(isA<ApiException>()),
      );
    });

    /// R21: calls patch with inverse isActive = false when active is true.
    test('R21: calls patch with inverse isActive = false when active is true', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: 'srv-123', isActive: false));

      // act
      await datasource.toggleActive(activeService);

      // assert
      verify(() => mockApiClient.patch<dynamic>(
            Endpoints.servicesToggleActive.fillId(activeService.id),
            data: {'isActive': false},
          )).called(1);
    });

    /// R22: calls patch with inverse isActive = true when active is false.
    test('R22: calls patch with inverse isActive = true when active is false', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: 'srv-123', isActive: true));

      // act
      await datasource.toggleActive(inactiveService);

      // assert
      verify(() => mockApiClient.patch<dynamic>(
            Endpoints.servicesToggleActive.fillId(inactiveService.id),
            data: {'isActive': true},
          )).called(1);
    });
  });
}
