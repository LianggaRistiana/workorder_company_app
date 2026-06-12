import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/provider_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/data/model/provider_integration_data_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ProviderIntegrationRemoteDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = ProviderIntegrationRemoteDatasourceImpl(mockApiClient);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  Map<String, dynamic> makeProviderIntegrationJson() => {
        'external_login_url': 'https://login.example.com',
        'external_verify_url': 'https://verify.example.com',
        'secret_key': 'secret-123',
        'external_check_memberships_url': 'https://memberships.example.com',
        'is_integration_active': true,
        'integration_type': 'external_system',
      };

  Map<String, dynamic> makeSingleResponse(Map<String, dynamic> data) => {
        'message': 'success',
        'data': data,
      };

  // ═══════════════════════════════════════════════════════════════════════
  // getProviderIntegrationData  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getProviderIntegrationData —', () {
    test('R16: returns ApiResponse<ProviderIntegrationDataModel> on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeSingleResponse(makeProviderIntegrationJson()));

      final result = await datasource.getProviderIntegrationData();

      expect(result.message, 'success');
      expect(result.data.secretKey, 'secret-123');
    });

    test('R17: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      expect(
        () => datasource.getProviderIntegrationData(),
        throwsA(isA<ApiException>()),
      );
    });

    test('R18: calls get with correct endpoint', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => makeSingleResponse(makeProviderIntegrationJson()));

      await datasource.getProviderIntegrationData();

      verify(() => mockApiClient.get(Endpoints.systemIntegration)).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updateProviderIntegrationData  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('updateProviderIntegrationData —', () {
    const model = ProviderIntegrationDataModel(
      externalLoginUrl: 'https://login.example.com',
      externalVerifyUrl: 'https://verify.example.com',
      secretKey: 'secret-123',
      externalCheckStatusMembershipsUrl: 'https://memberships.example.com',
      isIntegrationActive: true,
      integrationType: IntegrationType.externalSystem,
    );

    test('R19: returns ApiResponse<ProviderIntegrationDataModel> on success', () async {
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => makeSingleResponse(makeProviderIntegrationJson()));

      final result = await datasource.updateProviderIntegrationData(model);

      expect(result.message, 'success');
      expect(result.data.secretKey, 'secret-123');
    });

    test('R20: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(
        () => datasource.updateProviderIntegrationData(model),
        throwsA(isA<ApiException>()),
      );
    });

    test('R21: calls put with correct endpoint and payload', () async {
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => makeSingleResponse(makeProviderIntegrationJson()));

      await datasource.updateProviderIntegrationData(model);

      verify(() => mockApiClient.put(
            Endpoints.systemIntegration,
            data: model.toJson(),
          )).called(1);
    });
  });
}
