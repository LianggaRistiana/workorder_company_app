import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/features/memberships/data/datasources/memberships_remote_datasource.dart';
import 'package:workorder_company_app/features/memberships/data/model/member_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_model.dart';
import 'package:workorder_company_app/features/system_integration/data/model/external_user_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late MembershipsRemoteDatasourceImpl datasource;
  late File tempFile;
  late String tempFilePath;

  setUpAll(() {
    registerFallbackValue(FormData());
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = MembershipsRemoteDatasourceImpl(mockApiClient);

    // Create temporary file for upload testing
    tempFile = File('temp_test_csv.csv')..writeAsStringSync('token,email,name\nTOK1,a@b.com,Name');
    tempFilePath = tempFile.path;
  });

  tearDown(() {
    if (tempFile.existsSync()) {
      tempFile.deleteSync();
    }
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  Map<String, dynamic> externalUserJson() => {
        '_id': 'ext-user-123',
        'integrationType': 'external_system',
        'externalCustomerEmail': 'ext@example.com',
        'externalCustomerName': 'External User',
        'company': {
          '_id': 'comp-123',
          'name': 'PT Jaya',
          'address': 'Jl. Raya',
          'isActive': true,
          'isFaqActive': false,
        },
        'pairedAt': '2026-06-12T03:37:03Z',
      };

  Map<String, dynamic> userJson() => {
        '_id': 'uid-123',
        'name': 'Budi',
        'email': 'budi@example.com',
        'role': 'client',
        'position': null,
      };

  Map<String, dynamic> membershipCodeJson({String id = 'code-123'}) => {
        '_id': id,
        'token': 'TOKEN123',
        'externalCustomerEmail': 'cust@example.com',
        'externalCustomerName': 'Customer Name',
        'claimedAt': null,
      };

  Map<String, dynamic> memberJson() => {
        'externalAccount': externalUserJson(),
        'user': userJson(),
      };

  Map<String, dynamic> claimResponseJson() => {
        'message': 'success',
        'data': externalUserJson(),
      };

  Map<String, dynamic> singleCodeResponseJson({String id = 'code-123'}) => {
        'message': 'success',
        'data': membershipCodeJson(id: id),
      };

  Map<String, dynamic> listCodeResponseJson() => {
        'message': 'success',
        'data': [membershipCodeJson(id: 'code-123')],
      };

  Map<String, dynamic> listMembersResponseJson() => {
        'message': 'success',
        'data': [memberJson()],
      };

  // ═══════════════════════════════════════════════════════════════════════
  // claimMembership  │  Cyclomatic Complexity = 1
  //                  │  Paths: success returns external user, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('claimMembership —', () {
    /// R1: returns ApiResponse<ExternalUserModel> on success.
    test('R1: returns ApiResponse<ExternalUserModel> on success', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => claimResponseJson());

      final result = await datasource.claimMembership('TOKEN123', 'comp-123');

      expect(result.data, isA<ExternalUserModel>());
      expect(result.data.id, 'ext-user-123');
      expect(result.data.externalEmail, 'ext@example.com');
    });

    /// R2: propagates ApiException.
    test('R2: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Invalid token'));

      await expectLater(
        () async => datasource.claimMembership('TOKEN123', 'comp-123'),
        throwsA(isA<ApiException>()),
      );
    });

    /// R3: calls post with correct endpoint and payload.
    test('R3: calls post with correct endpoint and payload', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => claimResponseJson());

      await datasource.claimMembership('TOKEN123', 'comp-123');

      verify(() => mockApiClient.post<dynamic>(
            Endpoints.claimMembership,
            data: {
              'code': 'TOKEN123',
              'companyId': 'comp-123',
            },
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // deleteMemberShipCode  │  Cyclomatic Complexity = 1
  //                       │  Paths: success returns code model, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('deleteMemberShipCode —', () {
    /// R4: returns ApiResponse<MembershipCodeModel> on success.
    test('R4: returns ApiResponse<MembershipCodeModel> on success', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => singleCodeResponseJson(id: 'code-123'));

      final result = await datasource.deleteMemberShipCode('code-123');

      expect(result.data, isA<MembershipCodeModel>());
      expect(result.data.id, 'code-123');
    });

    /// R5: propagates ApiException.
    test('R5: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenThrow(ApiException(404, 'Code not found'));

      await expectLater(
        () async => datasource.deleteMemberShipCode('code-123'),
        throwsA(isA<ApiException>()),
      );
    });

    /// R6: calls delete with correct filled endpoint.
    test('R6: calls delete with correct filled endpoint', () async {
      when(() => mockApiClient.delete<dynamic>(any()))
          .thenAnswer((_) async => singleCodeResponseJson(id: 'code-123'));

      await datasource.deleteMemberShipCode('code-123');

      verify(() => mockApiClient.delete<dynamic>(
            Endpoints.membershipCodes.byId('code-123'),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getMembershipCodes  │  Cyclomatic Complexity = 1
  //                     │  Paths: success returns list, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getMembershipCodes —', () {
    /// R7: returns ApiResponse<List<MembershipCodeModel>> on success.
    test('R7: returns ApiResponse<List<MembershipCodeModel>> on success', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listCodeResponseJson());

      final result = await datasource.getMembershipCodes();

      expect(result.data, isA<List<MembershipCodeModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'code-123');
    });

    /// R8: propagates ApiException.
    test('R8: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Server Error'));

      await expectLater(
        () async => datasource.getMembershipCodes(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R9: calls get with correct endpoint.
    test('R9: calls get with correct endpoint', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listCodeResponseJson());

      await datasource.getMembershipCodes();

      verify(() => mockApiClient.get<dynamic>(Endpoints.membershipCodes)).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getMembers  │  Cyclomatic Complexity = 1
  //             │  Paths: success returns list, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getMembers —', () {
    /// R10: returns ApiResponse<List<MemberModel>> on success.
    test('R10: returns ApiResponse<List<MemberModel>> on success', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listMembersResponseJson());

      final result = await datasource.getMembers();

      expect(result.data, isA<List<MemberModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.client.userId, 'uid-123');
    });

    /// R11: propagates ApiException.
    test('R11: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Server Error'));

      await expectLater(
        () async => datasource.getMembers(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R12: calls get with correct endpoint.
    test('R12: calls get with correct endpoint', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listMembersResponseJson());

      await datasource.getMembers();

      verify(() => mockApiClient.get<dynamic>(Endpoints.memberships)).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // uploadMembershipCsvFile  │  Cyclomatic Complexity = 1
  //                          │  Paths: success returns list, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('uploadMembershipCsvFile —', () {
    /// R13: returns ApiResponse<List<MembershipCodeModel>> on success.
    test('R13: returns ApiResponse<List<MembershipCodeModel>> on success', () async {
      when(() => mockApiClient.postFormData<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => listCodeResponseJson());

      final result = await datasource.uploadMembershipCsvFile(tempFilePath);

      expect(result.data, isA<List<MembershipCodeModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'code-123');
    });

    /// R14: propagates ApiException.
    test('R14: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.postFormData<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Invalid CSV format'));

      await expectLater(
        () async => datasource.uploadMembershipCsvFile(tempFilePath),
        throwsA(isA<ApiException>()),
      );
    });

    /// R15: calls postFormData with correct endpoint.
    test('R15: calls postFormData with correct endpoint', () async {
      when(() => mockApiClient.postFormData<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => listCodeResponseJson());

      await datasource.uploadMembershipCsvFile(tempFilePath);

      verify(() => mockApiClient.postFormData<dynamic>(
            Endpoints.membershipCodes,
            data: any(named: 'data'),
          )).called(1);
    });
  });
}
