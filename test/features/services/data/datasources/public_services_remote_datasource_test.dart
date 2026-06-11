import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/services/data/datasources/public_services_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late PublicServicesRemoteDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = PublicServicesRemoteDatasourceImpl(mockApiClient);
  });

  // ── Fixtures ────────────────────────────────────────────────────────────
  Map<String, dynamic> mockSummaryJson() => {
        '_id': 'srv-summary-123',
        'title': 'AC Service',
        'description': 'Regular maintenance',
        'accessType': 'public',
        'isActive': true,
        'price': 150000,
      };

  Map<String, dynamic> mockListResponseJson() => {
        'message': 'success',
        'data': [mockSummaryJson()],
      };

  // ═══════════════════════════════════════════════════════════════════════
  // getPublicServices  │  Cyclomatic Complexity = 1
  //                    │  Paths: success returns list, failure propagates ApiException
  // ═══════════════════════════════════════════════════════════════════════
  group('getPublicServices —', () {
    const companyId = 'company-123';

    /// R1: returns ApiResponse<List<ServiceSummaryModel>> on success.
    test('R1: returns ApiResponse<List<ServiceSummaryModel>> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => mockListResponseJson());

      // act
      final result = await datasource.getPublicServices(companyId);

      // assert
      expect(result.data, isA<List<ServiceSummaryModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'srv-summary-123');
    });

    /// R2: propagates ApiException when API client throws.
    test('R2: propagates ApiException when API client throws', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Server Error'));

      // act & assert
      await expectLater(
        () async => datasource.getPublicServices(companyId),
        throwsA(isA<ApiException>()),
      );
    });

    /// R3: calls get with the correct company public services endpoint.
    test('R3: calls get with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => mockListResponseJson());

      // act
      await datasource.getPublicServices(companyId);

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.publicCompanyServices(companyId),
          )).called(1);
    });
  });
}
