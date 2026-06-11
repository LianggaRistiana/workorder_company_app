import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/features/positions/data/datasources/positions_remote_datasource.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late PositionsRemoteDatasourceImpl datasource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = PositionsRemoteDatasourceImpl(mockApiClient);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  PositionModel makePositionModel() => const PositionModel(
        id: 'pos-123',
        name: 'Technician',
        description: 'Field Technician',
        isActive: true,
      );

  Map<String, dynamic> positionJson() => {
        '_id': 'pos-123',
        'name': 'Technician',
        'description': 'Field Technician',
        'isActive': true,
      };

  Map<String, dynamic> listResponseJson() => {
        'message': 'success',
        'data': [positionJson()],
      };

  Map<String, dynamic> singleResponseJson() => {
        'message': 'success',
        'data': positionJson(),
      };

  Map<String, dynamic> detailResponseJson() => {
        'message': 'success',
        'data': positionJson(),
        'meta': {
          'canDelete': true,
        },
      };

  Map<String, dynamic> deleteResponseJson() => {
        'message': 'deleted successfully',
        'data': const <String, dynamic>{},
      };

  // ═══════════════════════════════════════════════════════════════════════
  // getPositions  │  Cyclomatic Complexity = 1
  //               │  Paths: success returns response, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getPositions —', () {
    /// R1: returns ApiResponse<List<PositionModel>> on success.
    test('R1: returns ApiResponse<List<PositionModel>> on success', () async {
      when(() => mockApiClient.get<ApiResponse<List<PositionModel>>>(
            any(),
            fromJson: any(named: 'fromJson'),
          )).thenAnswer((invocation) async {
        final fromJson = invocation.namedArguments[#fromJson] as ApiResponse<List<PositionModel>> Function(dynamic);
        return fromJson(listResponseJson());
      });

      final result = await datasource.getPositions();

      expect(result.data, isA<List<PositionModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'pos-123');
    });

    /// R2: propagates ApiException when API call fails.
    test('R2: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.get<ApiResponse<List<PositionModel>>>(
            any(),
            fromJson: any(named: 'fromJson'),
          )).thenThrow(ApiException(500, 'Internal Server Error'));

      await expectLater(
        () async => datasource.getPositions(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R3: calls get with correct endpoint and invokes callback.
    test('R3: calls get with correct endpoint', () async {
      when(() => mockApiClient.get<ApiResponse<List<PositionModel>>>(
            any(),
            fromJson: any(named: 'fromJson'),
          )).thenAnswer((invocation) async {
        final fromJson = invocation.namedArguments[#fromJson] as ApiResponse<List<PositionModel>> Function(dynamic);
        return fromJson(listResponseJson());
      });

      await datasource.getPositions();

      verify(() => mockApiClient.get<ApiResponse<List<PositionModel>>>(
            Endpoints.positions,
            fromJson: any(named: 'fromJson'),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getPositionById  │  Cyclomatic Complexity = 1
  //                  │  Paths: success returns response with meta, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getPositionById —', () {
    /// R4: returns ApiResponseWithMeta<PositionModel> on success.
    test('R4: returns ApiResponseWithMeta<PositionModel> on success', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => detailResponseJson());

      final result = await datasource.getPositionById('pos-123');

      expect(result.data, isA<PositionModel>());
      expect(result.data!.id, 'pos-123');
      expect(result.meta, isNotNull);
      expect(result.meta!['canDelete'], isTrue);
    });

    /// R5: propagates ApiException.
    test('R5: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(404, 'Position not found'));

      await expectLater(
        () async => datasource.getPositionById('pos-123'),
        throwsA(isA<ApiException>()),
      );
    });

    /// R6: calls get with correct detail endpoint.
    test('R6: calls get with correct detail endpoint', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => detailResponseJson());

      await datasource.getPositionById('pos-123');

      verify(() => mockApiClient.get<dynamic>(
            Endpoints.positions.byId('pos-123'),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // createPosition  │  Cyclomatic Complexity = 1
  //                 │  Paths: success returns code, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('createPosition —', () {
    final posModel = makePositionModel();

    /// R7: returns ApiResponse<PositionModel> on success.
    test('R7: returns ApiResponse<PositionModel> on success', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      final result = await datasource.createPosition(posModel);

      expect(result.data, isA<PositionModel>());
      expect(result.data.id, 'pos-123');
    });

    /// R8: propagates ApiException.
    test('R8: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad request'));

      await expectLater(
        () async => datasource.createPosition(posModel),
        throwsA(isA<ApiException>()),
      );
    });

    /// R9: calls post with correct endpoint and payload.
    test('R9: calls post with correct endpoint and payload', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      await datasource.createPosition(posModel);

      verify(() => mockApiClient.post<dynamic>(
            Endpoints.positions,
            data: posModel.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updatePosition  │  Cyclomatic Complexity = 1
  //                 │  Paths: success returns code, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('updatePosition —', () {
    final posModel = makePositionModel();

    /// R10: returns ApiResponse<PositionModel> on success.
    test('R10: returns ApiResponse<PositionModel> on success', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      final result = await datasource.updatePosition(posModel);

      expect(result.data, isA<PositionModel>());
      expect(result.data.id, 'pos-123');
    });

    /// R11: propagates ApiException.
    test('R11: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(403, 'Forbidden'));

      await expectLater(
        () async => datasource.updatePosition(posModel),
        throwsA(isA<ApiException>()),
      );
    });

    /// R12: calls put with correct endpoint and payload.
    test('R12: calls put with correct endpoint and payload', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      await datasource.updatePosition(posModel);

      verify(() => mockApiClient.put<dynamic>(
            Endpoints.positions.byId(posModel.id),
            data: posModel.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // deletePosition  │  Cyclomatic Complexity = 1
  //                 │  Paths: success returns Empty, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('deletePosition —', () {
    /// R13: returns ApiResponse<Empty> on success.
    test('R13: returns ApiResponse<Empty> on success', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => deleteResponseJson());

      final result = await datasource.deletePosition('pos-123');

      expect(result.data, isA<Empty>());
    });

    /// R14: propagates ApiException.
    test('R14: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenThrow(ApiException(400, 'Cannot delete position'));

      await expectLater(
        () async => datasource.deletePosition('pos-123'),
        throwsA(isA<ApiException>()),
      );
    });

    /// R15: calls delete with correct filled endpoint.
    test('R15: calls delete with correct filled endpoint', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => deleteResponseJson());

      await datasource.deletePosition('pos-123');

      verify(() => mockApiClient.delete<dynamic>(
            Endpoints.positions.byId('pos-123'),
          )).called(1);
    });
  });
}
