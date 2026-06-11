import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_management_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/datasources/public_companies_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late CompanyManagementRemoteDatasourceImpl companyManagementDatasource;
  late PublicCompaniesRemoteDatasourceImpl publicCompaniesDatasource;

  setUpAll(() {
    registerFallbackValue(CompanyModel(
      id: 'co-001',
      name: 'PT Maju Bersama',
      address: 'Jl. Sudirman No.1',
      description: 'Perusahaan logistik',
      isActive: true,
      isFaqActive: false,
    ));
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    companyManagementDatasource = CompanyManagementRemoteDatasourceImpl(mockApiClient);
    publicCompaniesDatasource = PublicCompaniesRemoteDatasourceImpl(mockApiClient);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  Map<String, dynamic> companyJson() => {
        '_id': 'co-001',
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': 'Perusahaan logistik',
        'isActive': true,
        'isFaqActive': false,
      };

  Map<String, dynamic> apiResponseJson({required dynamic data}) => {
        'message': 'OK',
        'data': data,
      };

  Map<String, dynamic> apiResponseWithMetaJson({
    required dynamic data,
    required Map<String, dynamic> meta,
  }) =>
      {
        'message': 'OK',
        'data': data,
        'meta': meta,
      };

  // ═══════════════════════════════════════════════════════════════════════
  // getCompanyInformation  │  Cyclomatic Complexity = 1
  //                        │  Paths: happy path | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('CompanyManagementRemoteDatasourceImpl.getCompanyInformation —', () {
    /// R1 | Branch: happy path
    /// Expected: returns ApiResponse<CompanyModel> with parsed data
    test('R1: getCompanyInformation returns ApiResponse<CompanyModel> on success', () async {
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: companyJson()));

      final response = await companyManagementDatasource.getCompanyInformation();

      expect(response, isA<ApiResponse<CompanyModel>>());
      expect(response.data.id, 'co-001');
      expect(response.data.name, 'PT Maju Bersama');
    });

    /// R2 | Branch: error propagation
    /// Expected: propagates ApiException thrown by ApiClient
    test('R2: getCompanyInformation propagates ApiException on error', () async {
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(500, 'Server Error'));

      await expectLater(
        () => companyManagementDatasource.getCompanyInformation(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updateCompanyInformation  │  Cyclomatic Complexity = 1
  //                           │  Paths: happy path | argument verification | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('CompanyManagementRemoteDatasourceImpl.updateCompanyInformation —', () {
    final updatedModel = CompanyModel(
      id: 'co-001',
      name: 'PT Maju Bersama Baru',
      address: 'Jl. Sudirman No.2',
      description: 'Perusahaan logistik baru',
      isActive: true,
      isFaqActive: true,
    );

    /// R3 | Branch: happy path
    /// Expected: returns ApiResponse<CompanyModel> with updated data
    test('R3: updateCompanyInformation returns ApiResponse<CompanyModel> on success', () async {
      final updatedJson = updatedModel.toJson()..['_id'] = updatedModel.id;
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: updatedJson));

      final response = await companyManagementDatasource.updateCompanyInformation(updatedModel);

      expect(response, isA<ApiResponse<CompanyModel>>());
      expect(response.data.id, 'co-001');
      expect(response.data.name, 'PT Maju Bersama Baru');
    });

    /// R4 | Branch: argument verification
    /// Expected: put is called with correct endpoint and serialized JSON body
    test('R4: updateCompanyInformation calls API put with correct endpoint and body', () async {
      final updatedJson = updatedModel.toJson()..['_id'] = updatedModel.id;
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: updatedJson));

      await companyManagementDatasource.updateCompanyInformation(updatedModel);

      verify(() => mockApiClient.put<dynamic>(
            Endpoints.company,
            data: updatedModel.toJson(),
          )).called(1);
    });

    /// R5 | Branch: error propagation
    /// Expected: propagates ApiException thrown by ApiClient
    test('R5: updateCompanyInformation propagates ApiException on error', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(400, 'Bad Request'));

      await expectLater(
        () => companyManagementDatasource.updateCompanyInformation(updatedModel),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getCompanies  │  Cyclomatic Complexity = 1
  //               │  Paths: happy path | empty list | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('PublicCompaniesRemoteDatasourceImpl.getCompanies —', () {
    /// R6 | Branch: happy path
    /// Expected: returns ApiResponse<List<CompanyModel>> with parsed list
    test('R6: getCompanies returns ApiResponse<List<CompanyModel>> on success', () async {
      final listData = [companyJson(), companyJson()];
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: listData));

      final response = await publicCompaniesDatasource.getCompanies();

      expect(response.data, isA<List<CompanyModel>>());
      expect(response.data.length, 2);
      expect(response.data[0].id, 'co-001');
    });

    /// R7 | Branch: empty list handling
    /// Expected: returns empty List<CompanyModel> when API data is empty
    test('R7: getCompanies returns empty list when API returns empty array', () async {
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: []));

      final response = await publicCompaniesDatasource.getCompanies();

      expect(response.data, isA<List<CompanyModel>>());
      expect(response.data.isEmpty, isTrue);
    });

    /// R8 | Branch: error propagation
    /// Expected: propagates ApiException thrown by ApiClient
    test('R8: getCompanies propagates ApiException on error', () async {
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(500, 'Server Error'));

      await expectLater(
        () => publicCompaniesDatasource.getCompanies(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getCompanyById  │  Cyclomatic Complexity = 1
  //                 │  Paths: happy path | endpoint verification | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('PublicCompaniesRemoteDatasourceImpl.getCompanyById —', () {
    final targetId = 'co-123';
    final expectedEndpoint = Endpoints.publicCompanies.byId(targetId);

    /// R9 | Branch: happy path
    /// Expected: returns ApiResponseWithMeta<CompanyModel>
    test('R9: getCompanyById returns ApiResponseWithMeta<CompanyModel> on success', () async {
      final meta = {'isSubscribed': true, 'isIntegrationActive': false};
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseWithMetaJson(data: companyJson(), meta: meta));

      final response = await publicCompaniesDatasource.getCompanyById(targetId);

      expect(response, isA<ApiResponseWithMeta<CompanyModel>>());
      expect(response.data, isNotNull);
      expect(response.data!.id, 'co-001');
      expect(response.meta?['isSubscribed'], isTrue);
    });

    /// R10 | Branch: endpoint verification
    /// Expected: get is called with correct path Interpolated with ID
    test('R10: getCompanyById calls API get with correct ID-based endpoint path', () async {
      final meta = {'isSubscribed': true, 'isIntegrationActive': false};
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseWithMetaJson(data: companyJson(), meta: meta));

      await publicCompaniesDatasource.getCompanyById(targetId);

      verify(() => mockApiClient.get<dynamic>(
            expectedEndpoint,
          )).called(1);
    });

    /// R11 | Branch: error propagation
    /// Expected: propagates ApiException thrown by ApiClient
    test('R11: getCompanyById propagates ApiException on error', () async {
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(404, 'Not Found'));

      await expectLater(
        () => publicCompaniesDatasource.getCompanyById(targetId),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
