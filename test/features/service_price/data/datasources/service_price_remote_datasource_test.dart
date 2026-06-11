import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/service_price/data/datasources/service_price_remote_datasource.dart';
import 'package:workorder_company_app/features/service_price/data/model/service_price_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ServicePriceRemoteDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = ServicePriceRemoteDatasourceImpl(mockApiClient);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  ServiceSummaryModel makeSummaryModel() => const ServiceSummaryModel(
        id: 'srv-123',
        title: 'AC Service',
        description: 'Regular maintenance',
        accessType: ServiceAccessType.public,
        isActive: true,
        price: 150000,
      );

  Map<String, dynamic> summaryJson() => {
        '_id': 'srv-123',
        'title': 'AC Service',
        'description': 'Regular maintenance',
        'accessType': 'public',
        'isActive': true,
        'price': 150000,
      };

  ServicePriceModel makeServicePriceModel() => ServicePriceModel(
        id: 'sp-123',
        service: makeSummaryModel(),
        price: 120000,
      );

  Map<String, dynamic> servicePriceJson({String id = 'sp-123'}) => {
        '_id': id,
        'service': summaryJson(),
        'price': 120000,
      };

  Map<String, dynamic> singleResponseJson({String id = 'sp-123'}) => {
        'message': 'success',
        'data': servicePriceJson(id: id),
      };

  Map<String, dynamic> listResponseJson() => {
        'message': 'success',
        'data': [servicePriceJson()],
      };

  // ═══════════════════════════════════════════════════════════════════════
  // addServicePrice  │  Cyclomatic Complexity = 1
  //                  │  Paths: success returns response, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('addServicePrice —', () {
    final model = makeServicePriceModel();

    /// R1: returns ApiResponse<ServicePriceModel> on success.
    test('R1: returns ApiResponse<ServicePriceModel> on success', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.addServicePrice(model);

      // assert
      expect(result.data, isA<ServicePriceModel>());
      expect(result.data.id, 'sp-123');
    });

    /// R2: propagates ApiException when API client fails.
    test('R2: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.addServicePrice(model),
        throwsA(isA<ApiException>()),
      );
    });

    /// R3: calls post with correct endpoint and payload.
    test('R3: calls post with correct endpoint and payload', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.addServicePrice(model);

      // assert
      verify(() => mockApiClient.post<dynamic>(
            Endpoints.servicePrice,
            data: model.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // deleteServicePrice  │  Cyclomatic Complexity = 1
  //                     │  Paths: success returns response, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('deleteServicePrice —', () {
    const id = 'sp-123';

    /// R4: returns ApiResponse<ServicePriceModel> on success.
    test('R4: returns ApiResponse<ServicePriceModel> on success', () async {
      // arrange
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.deleteServicePrice(id);

      // assert
      expect(result.data, isA<ServicePriceModel>());
      expect(result.data.id, id);
    });

    /// R5: propagates ApiException when API client fails.
    test('R5: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.deleteServicePrice(id),
        throwsA(isA<ApiException>()),
      );
    });

    /// R6: calls delete with correct endpoint.
    test('R6: calls delete with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.deleteServicePrice(id);

      // assert
      verify(() => mockApiClient.delete<dynamic>(
            Endpoints.servicePriceDetail.fillId(id),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServicePrices  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns response, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getServicePrices —', () {
    /// R7: returns ApiResponse<List<ServicePriceModel>> on success.
    test('R7: returns ApiResponse<List<ServicePriceModel>> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      // act
      final result = await datasource.getServicePrices();

      // assert
      expect(result.data, isA<List<ServicePriceModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'sp-123');
    });

    /// R8: propagates ApiException when API client fails.
    test('R8: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Server Error'));

      // act & assert
      await expectLater(
        () async => datasource.getServicePrices(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R9: calls get with correct endpoint.
    test('R9: calls get with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      // act
      await datasource.getServicePrices();

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.servicePrice,
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updateServicePrice  │  Cyclomatic Complexity = 1
  //                     │  Paths: success returns response, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('updateServicePrice —', () {
    final model = makeServicePriceModel();

    /// R10: returns ApiResponse<ServicePriceModel> on success.
    test('R10: returns ApiResponse<ServicePriceModel> on success', () async {
      // arrange
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.updateServicePrice(model);

      // assert
      expect(result.data, isA<ServicePriceModel>());
      expect(result.data.id, 'sp-123');
    });

    /// R11: propagates ApiException when API client fails.
    test('R11: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.updateServicePrice(model),
        throwsA(isA<ApiException>()),
      );
    });

    /// R12: calls put with correct endpoint and payload.
    test('R12: calls put with correct endpoint and payload', () async {
      // arrange
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.updateServicePrice(model);

      // assert
      verify(() => mockApiClient.put<dynamic>(
            Endpoints.servicePriceDetail.fillId(model.id),
            data: model.toJson(),
          )).called(1);
    });
  });
}
