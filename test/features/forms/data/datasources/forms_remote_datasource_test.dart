import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late FormsRemoteDatasourceImpl datasource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = FormsRemoteDatasourceImpl(mockApiClient);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  FormModel makeFormModel() => const FormModel(
        id: 'form-id-123',
        title: 'Inspection Form',
        formType: FormType.workOrder,
        description: 'Inspection description',
        fields: [],
      );

  Map<String, dynamic> formJson() => {
        '_id': 'form-id-123',
        'title': 'Inspection Form',
        'formType': 'work_order',
        'description': 'Inspection description',
        'fields': [],
      };

  Map<String, dynamic> listResponseJson() => {
        'message': 'success',
        'data': [formJson()],
      };

  Map<String, dynamic> singleResponseJson() => {
        'message': 'success',
        'data': formJson(),
      };

  Map<String, dynamic> detailResponseJson() => {
        'message': 'success',
        'data': formJson(),
        'meta': {
          'totalSubmissions': 10,
        },
      };

  Map<String, dynamic> deleteResponseJson() => {
        'message': 'deleted successfully',
        'data': const <String, dynamic>{},
      };

  // ═══════════════════════════════════════════════════════════════════════
  // getForms  │  Cyclomatic Complexity = 1
  //           │  Paths: success maps list, failure propagates ApiException
  // ═══════════════════════════════════════════════════════════════════════
  group('getForms —', () {
    /// R1: returns ApiResponse<List<FormModel>> on success.
    test('R1: returns ApiResponse<List<FormModel>> on success', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      final result = await datasource.getForms();

      expect(result.data, isA<List<FormModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'form-id-123');
    });

    /// R2: propagates ApiException when api call fails.
    test('R2: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Internal Server Error'));

      await expectLater(
        () async => datasource.getForms(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R3: calls get with Endpoints.forms.
    test('R3: calls get with correct endpoint', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      await datasource.getForms();

      verify(() => mockApiClient.get<dynamic>(Endpoints.forms)).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getFormById  │  Cyclomatic Complexity = 1
  //              │  Paths: success returns ApiResponseWithMeta, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getFormById —', () {
    /// R4: returns ApiResponseWithMeta<FormModel> on success.
    test('R4: returns ApiResponseWithMeta<FormModel> on success', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => detailResponseJson());

      final result = await datasource.getFormById('form-id-123');

      expect(result.data, isA<FormModel>());
      expect(result.data!.id, 'form-id-123');
      expect(result.meta, isNotNull);
      expect(result.meta!['totalSubmissions'], 10);
    });

    /// R5: propagates ApiException.
    test('R5: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(404, 'Form not found'));

      await expectLater(
        () async => datasource.getFormById('form-id-123'),
        throwsA(isA<ApiException>()),
      );
    });

    /// R6: calls get with correct detail endpoint.
    test('R6: calls get with correct detail endpoint', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => detailResponseJson());

      await datasource.getFormById('form-id-123');

      verify(() => mockApiClient.get<dynamic>(Endpoints.forms.byId('form-id-123'))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // createForm  │  Cyclomatic Complexity = 1
  //             │  Paths: success returns form, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('createForm —', () {
    final formModel = makeFormModel();

    /// R7: returns ApiResponse<FormModel> on success.
    test('R7: returns ApiResponse<FormModel> on success', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      final result = await datasource.createForm(formModel);

      expect(result.data, isA<FormModel>());
      expect(result.data.id, 'form-id-123');
    });

    /// R8: propagates ApiException.
    test('R8: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      await expectLater(
        () async => datasource.createForm(formModel),
        throwsA(isA<ApiException>()),
      );
    });

    /// R9: calls post with correct endpoint and payload.
    test('R9: calls post with correct endpoint and payload', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      await datasource.createForm(formModel);

      verify(() => mockApiClient.post<dynamic>(
            Endpoints.forms,
            data: formModel.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updateForm  │  Cyclomatic Complexity = 1
  //             │  Paths: success returns updated form, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('updateForm —', () {
    final formModel = makeFormModel();

    /// R10: returns ApiResponse<FormModel> on success.
    test('R10: returns ApiResponse<FormModel> on success', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      final result = await datasource.updateForm(formModel);

      expect(result.data, isA<FormModel>());
      expect(result.data.id, 'form-id-123');
    });

    /// R11: propagates ApiException.
    test('R11: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(403, 'Forbidden'));

      await expectLater(
        () async => datasource.updateForm(formModel),
        throwsA(isA<ApiException>()),
      );
    });

    /// R12: calls put with correct endpoint and payload.
    test('R12: calls put with correct endpoint and payload', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      await datasource.updateForm(formModel);

      verify(() => mockApiClient.put<dynamic>(
            Endpoints.forms.byId(formModel.id),
            data: formModel.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // deleteForm  │  Cyclomatic Complexity = 1
  //             │  Paths: success returns Empty, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('deleteForm —', () {
    final formModel = makeFormModel();

    /// R13: returns ApiResponse<Empty> on success.
    test('R13: returns ApiResponse<Empty> on success', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => deleteResponseJson());

      final result = await datasource.deleteForm(formModel);

      expect(result.data, isA<Empty>());
    });

    /// R14: propagates ApiException.
    test('R14: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenThrow(ApiException(400, 'Cannot delete form'));

      await expectLater(
        () async => datasource.deleteForm(formModel),
        throwsA(isA<ApiException>()),
      );
    });

    /// R15: calls delete with correct endpoint.
    test('R15: calls delete with correct endpoint', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => deleteResponseJson());

      await datasource.deleteForm(formModel);

      verify(() => mockApiClient.delete<dynamic>(
            Endpoints.forms.byId(formModel.id),
          )).called(1);
    });
  });
}
