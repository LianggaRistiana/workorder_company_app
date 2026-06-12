import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/customer_account_integration_remote_datasource.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late CustomerAccountIntegrationRemoteDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = CustomerAccountIntegrationRemoteDatasourceImpl(mockApiClient);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  Map<String, dynamic> makeCompanyJson() => {
        '_id': 'comp-123',
        'name': 'Test Company',
        'address': '123 Test St',
        'description': 'Description',
        'isActive': true,
        'isFaqActive': false,
      };

  Map<String, dynamic> makeExternalUserJson({String id = 'eu-123'}) => {
        '_id': id,
        'integrationType': 'external_system',
        'externalCustomerEmail': 'external@example.com',
        'externalCustomerName': 'External User',
        'company': makeCompanyJson(),
        'pairedAt': '2026-06-12T03:37:03Z',
      };

  Map<String, dynamic> makeStartPairingJson() => {
        'redirect_url': 'https://redirect.example.com',
      };

  Map<String, dynamic> makeSingleResponse(Map<String, dynamic> data) => {
        'message': 'success',
        'data': data,
      };

  Map<String, dynamic> makeListResponse(List<Map<String, dynamic>> dataList) => {
        'message': 'success',
        'data': dataList,
      };

  // ═══════════════════════════════════════════════════════════════════════
  // startPairing  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('startPairing —', () {
    const companyId = 'comp-123';

    test('R1: returns ApiResponse<StartPairingDataModel> on success', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => makeSingleResponse(makeStartPairingJson()));

      final result = await datasource.startPairing(companyId);

      expect(result.message, 'success');
      expect(result.data.redirectUrl, 'https://redirect.example.com');
    });

    test('R2: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(
        () => datasource.startPairing(companyId),
        throwsA(isA<ApiException>()),
      );
    });

    test('R3: calls post with correct endpoint and payload', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => makeSingleResponse(makeStartPairingJson()));

      await datasource.startPairing(companyId);

      verify(() => mockApiClient.post(
            Endpoints.startPairing,
            data: {
              "company_id": companyId,
              "redirect_base_url": "com.workorder.saas://pair/callback"
            },
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // completePairing  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('completePairing —', () {
    const companyId = 'comp-123';
    const code = 'auth-code-123';
    const state = 'state-xyz';

    test('R4: returns ApiResponse<ExternalUserModel> on success', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => makeSingleResponse(makeExternalUserJson()));

      final result = await datasource.completePairing(
        companyId: companyId,
        code: code,
        state: state,
      );

      expect(result.message, 'success');
      expect(result.data.id, 'eu-123');
    });

    test('R5: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(
        () => datasource.completePairing(
          companyId: companyId,
          code: code,
          state: state,
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('R6: calls post with correct endpoint and payload', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => makeSingleResponse(makeExternalUserJson()));

      await datasource.completePairing(
        companyId: companyId,
        code: code,
        state: state,
      );

      verify(() => mockApiClient.post(
            Endpoints.completePairing,
            data: {
              "company_id": companyId,
              "code": code,
              "state": state,
            },
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getAccountPairingStatus  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getAccountPairingStatus —', () {
    const companyId = 'comp-123';

    test('R7: returns ApiResponse<ExternalUserModel> on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeSingleResponse(makeExternalUserJson()));

      final result = await datasource.getAccountPairingStatus(companyId);

      expect(result.message, 'success');
      expect(result.data.id, 'eu-123');
    });

    test('R8: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      expect(
        () => datasource.getAccountPairingStatus(companyId),
        throwsA(isA<ApiException>()),
      );
    });

    test('R9: calls get with correct endpoint', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeSingleResponse(makeExternalUserJson()));

      await datasource.getAccountPairingStatus(companyId);

      verify(() => mockApiClient.get(Endpoints.accountPairing.fillId(companyId))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // detachAccountPairing  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('detachAccountPairing —', () {
    const companyId = 'comp-123';

    test('R10: returns ApiResponse<ExternalUserModel> on success', () async {
      when(() => mockApiClient.delete(any()))
          .thenAnswer((_) async => makeSingleResponse(makeExternalUserJson()));

      final result = await datasource.detachAccountPairing(companyId);

      expect(result.message, 'success');
      expect(result.data.id, 'eu-123');
    });

    test('R11: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.delete(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(
        () => datasource.detachAccountPairing(companyId),
        throwsA(isA<ApiException>()),
      );
    });

    test('R12: calls delete with correct endpoint', () async {
      when(() => mockApiClient.delete(any()))
          .thenAnswer((_) async => makeSingleResponse(makeExternalUserJson()));

      await datasource.detachAccountPairing(companyId);

      verify(() => mockApiClient.delete(Endpoints.detachAccountPairing.fillId(companyId))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getAllAccountsPairingStatus  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getAllAccountsPairingStatus —', () {
    test('R13: returns ApiResponse<List<ExternalUserModel>> on success', () async {
      when(() => mockApiClient.get(any())).thenAnswer((_) async => makeListResponse([
            makeExternalUserJson(id: 'eu-1'),
            makeExternalUserJson(id: 'eu-2'),
          ]));

      final result = await datasource.getAllAccountsPairingStatus();

      expect(result.message, 'success');
      expect(result.data.length, 2);
      expect(result.data[0].id, 'eu-1');
      expect(result.data[1].id, 'eu-2');
    });

    test('R14: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(ApiException(500, 'Server Error'));

      expect(
        () => datasource.getAllAccountsPairingStatus(),
        throwsA(isA<ApiException>()),
      );
    });

    test('R15: calls get with correct endpoint', () async {
      when(() => mockApiClient.get(any())).thenAnswer((_) async => makeListResponse([]));

      await datasource.getAllAccountsPairingStatus();

      verify(() => mockApiClient.get(Endpoints.allAccountPairing)).called(1);
    });
  });
}
