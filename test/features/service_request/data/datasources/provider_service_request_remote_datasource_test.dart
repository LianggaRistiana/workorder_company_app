import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/provider_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/model/provider_service_request_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ProviderServiceRequestRemoteDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = ProviderServiceRequestRemoteDatasourceImpl(mockApiClient);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  Map<String, dynamic> userJson({String id = 'uid-123', String role = 'client'}) => {
        '_id': id,
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': role,
        'position': null,
      };

  Map<String, dynamic> summaryJson() => {
        '_id': 'srv-123',
        'title': 'AC Service',
        'description': 'Regular maintenance',
        'accessType': 'public',
        'isActive': true,
        'price': 150000,
      };

  Map<String, dynamic> serviceRequestJson({String id = 'sr-123'}) => {
        '_id': id,
        'code': 'SR-CODE-001',
        'serviceRequestStatus': 'approved',
        'service': summaryJson(),
        'requestedBy': userJson(role: 'client'),
        'approvedBy': userJson(role: 'manager_company'),
        'reviewNeed': true,
        'serviceRequestApprovalAccessType': 'manager',
        'intakeForm': null,
        'reviewForm': null,
        'createdAt': '2026-06-12T03:37:03Z',
      };

  Map<String, dynamic> singleResponseJson({String id = 'sr-123'}) => {
        'message': 'success',
        'data': serviceRequestJson(id: id),
      };

  Map<String, dynamic> listResponseJson() => {
        'message': 'success',
        'data': [serviceRequestJson()],
      };

  // ═══════════════════════════════════════════════════════════════════════
  // approveServiceRequest  │  Cyclomatic Complexity = 1
  //                        │  Paths: success returns model, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('approveServiceRequest —', () {
    const id = 'sr-123';

    /// R1: returns ApiResponse<ProviderServiceRequestModel> on success.
    test('R1: returns ApiResponse<ProviderServiceRequestModel> on success', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.approveServiceRequest(id);

      // assert
      expect(result.data, isA<ProviderServiceRequestModel>());
      expect(result.data.id, id);
    });

    /// R2: propagates ApiException.
    test('R2: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.approveServiceRequest(id),
        throwsA(isA<ApiException>()),
      );
    });

    /// R3: calls patch with correct endpoint.
    test('R3: calls patch with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.approveServiceRequest(id);

      // assert
      verify(() => mockApiClient.patch<dynamic>(
            Endpoints.serviceRequestApprove.fillId(id),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServiceRequestDetail  │  Cyclomatic Complexity = 1
  //                          │  Paths: success returns model, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceRequestDetail —', () {
    const id = 'sr-123';

    /// R4: returns ApiResponse<ProviderServiceRequestModel> on success.
    test('R4: returns ApiResponse<ProviderServiceRequestModel> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.getServiceRequestDetail(id);

      // assert
      expect(result.data, isA<ProviderServiceRequestModel>());
      expect(result.data.id, id);
    });

    /// R5: propagates ApiException.
    test('R5: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      // act & assert
      await expectLater(
        () async => datasource.getServiceRequestDetail(id),
        throwsA(isA<ApiException>()),
      );
    });

    /// R6: calls get with correct endpoint.
    test('R6: calls get with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.getServiceRequestDetail(id);

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.serviceRequestDetail.fillId(id),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServiceRequests  │  Cyclomatic Complexity = 1
  //                     │  Paths: success returns list, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceRequests —', () {
    /// R7: returns ApiResponse<List<ProviderServiceRequestModel>> on success.
    test('R7: returns ApiResponse<List<ProviderServiceRequestModel>> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      // act
      final result = await datasource.getServiceRequests();

      // assert
      expect(result.data, isA<List<ProviderServiceRequestModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'sr-123');
    });

    /// R8: propagates ApiException.
    test('R8: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Server Error'));

      // act & assert
      await expectLater(
        () async => datasource.getServiceRequests(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R9: calls get with correct endpoint.
    test('R9: calls get with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      // act
      await datasource.getServiceRequests();

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.serviceRequestInbox,
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // rejectServiceRequest  │  Cyclomatic Complexity = 1
  //                       │  Paths: success returns model, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('rejectServiceRequest —', () {
    const id = 'sr-123';

    /// R10: returns ApiResponse<ProviderServiceRequestModel> on success.
    test('R10: returns ApiResponse<ProviderServiceRequestModel> on success', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.rejectServiceRequest(id);

      // assert
      expect(result.data, isA<ProviderServiceRequestModel>());
      expect(result.data.id, id);
    });

    /// R11: propagates ApiException.
    test('R11: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.rejectServiceRequest(id),
        throwsA(isA<ApiException>()),
      );
    });

    /// R12: calls patch with correct endpoint.
    test('R12: calls patch with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.rejectServiceRequest(id);

      // assert
      verify(() => mockApiClient.patch<dynamic>(
            Endpoints.serviceRequestReject.fillId(id),
          )).called(1);
    });
  });
}
