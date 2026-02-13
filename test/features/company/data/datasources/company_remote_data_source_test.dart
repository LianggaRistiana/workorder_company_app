import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/services/data/models/service_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late CompanyRemoteDatasourceImpl datasource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = CompanyRemoteDatasourceImpl(mockApiClient);
  });

  group('getCompanies', () {
    test('should return list of CompanyModel when API call is successful', () async {
      final fakeResponse = {
        "success": true,
        "data": [
          {
            "_id": "1",
            "name": "PT Maju",
            "address": "Denpasar",
            "description": "Desc",
            "isActive": true
          }
        ]
      };

      when(() => mockApiClient.get(Endpoints.publicCompanies))
          .thenAnswer((_) async => fakeResponse);

      final result = await datasource.getCompanies();

      expect(result, isA<ApiResponse<List<CompanyModel>>>());
      expect(result.data, isNotNull);
      expect(result.data!.length, 1);
      expect(result.data!.first.name, "PT Maju");

      verify(() => mockApiClient.get(Endpoints.publicCompanies)).called(1);
    });

    test('should throw exception when API call fails', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(Exception("Server error"));

      expect(
        () => datasource.getCompanies(),
        throwsException,
      );
    });
  });

  group('getCompanyById', () {
    test('should return CompanyModel when successful', () async {
      final fakeResponse = {
        "success": true,
        "data": {
          "_id": "1",
          "name": "PT Maju",
          "address": "Denpasar",
          "description": "Desc",
          "isActive": true
        }
      };

      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => fakeResponse);

      final result = await datasource.getCompanyById("1");

      expect(result.data, isA<CompanyModel>());
      expect(result.data?.id, "1");
      expect(result.data?.name, "PT Maju");

      verify(() => mockApiClient.get(Endpoints.publicCompanies.byId("1")))
          .called(1);
    });
  });

  group('getCompanyService', () {
    test('should return list of ServiceModel when successful', () async {
      final fakeResponse = {
        "success": true,
        "data": [
          {
            "_id": "10",
            "title": "Cleaning Service",
            "description": "Service desc",
            "accessType": "public",
            "isActive": true,
          }
        ]
      };

      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => fakeResponse);

      final result = await datasource.getCompanyService("1");

      expect(result.data, isA<List<ServiceModel>>());
      expect(result.data!.first.title, "Cleaning Service");

      verify(() => mockApiClient.get(Endpoints.publicCompanyServices("1")))
          .called(1);
    });
  });
}
