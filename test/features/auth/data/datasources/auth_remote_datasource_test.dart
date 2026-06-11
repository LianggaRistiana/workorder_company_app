import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/model/company_registration_model.dart';
import 'package:workorder_company_app/features/auth/data/model/user_registration_model.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late AuthRemoteDatasourceImpl datasource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = AuthRemoteDatasourceImpl(mockApiClient);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  Map<String, dynamic> loginResponseJson() => {
        'message': 'Login success',
        'data': {
          'token': 'jwt-token-abc',
          'user': {
            '_id': 'uid-001',
            'name': 'Budi',
            'email': 'budi@example.com',
            'role': 'owner_company',
            'position': null,
          },
        },
      };

  Map<String, dynamic> logoutResponseJson() => {
        'message': 'Logged out',
        'data': {'loggedOut': true},
      };

  Map<String, dynamic> userProfileJson() => {
        'message': 'OK',
        'data': {
          '_id': 'uid-001',
          'name': 'Budi',
          'email': 'budi@example.com',
          'role': 'owner_company',
          'position': null,
        },
      };

  // ═══════════════════════════════════════════════════════════════════════
  // login  │  Cyclomatic Complexity = 1 (datasource has no try-catch)
  // ═══════════════════════════════════════════════════════════════════════
  group('login —', () {
    /// R1 | Branch: happy path
    /// Expected: returns ApiResponse<LoginResponseModel> with correct token
    test('R1: returns ApiResponse<LoginResponseModel> on success', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => loginResponseJson());

      final result = await datasource.login('budi@example.com', 'password123');

      expect(result, isA<ApiResponse<dynamic>>());
      expect(result.data.token, 'jwt-token-abc');
      expect(result.data.user.email, 'budi@example.com');
    });

    /// R2 | Branch: ApiException propagation
    /// Expected: ApiException thrown propagates to caller
    test('R2: propagates ApiException when API call fails', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenThrow(ApiException(401, 'Unauthorized'));

      await expectLater(
        () async => datasource.login('wrong@example.com', 'wrong'),
        throwsA(isA<ApiException>()),
      );
    });

    /// R3 | Argument verification
    /// Expected: post called with Endpoints.login and correct body map
    test('R3: calls post with correct endpoint and credentials payload',
        () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => loginResponseJson());

      await datasource.login('budi@example.com', 'pass123');

      verify(() => mockApiClient.post(
            Endpoints.login,
            data: {'email': 'budi@example.com', 'password': 'pass123'},
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // logout  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('logout —', () {
    /// R4 | Branch: happy path
    /// Expected: ApiResponse<LogoutResponseModel> with loggedOut=true
    test('R4: returns ApiResponse<LogoutResponseModel> with loggedOut=true',
        () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => logoutResponseJson());

      final result = await datasource.logout();

      expect(result.data.loggedOut, isTrue);
    });

    /// R5 | Branch: exception propagation
    /// Expected: ApiException propagates
    test('R5: propagates ApiException from logout', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenThrow(ApiException(500, 'Server Error'));

      await expectLater(
        () async => datasource.logout(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getUser  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getUser —', () {
    /// R6 | Branch: happy path
    /// Expected: ApiResponse<UserModel> with correct email and role
    test('R6: returns ApiResponse<UserModel> on success', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => userProfileJson());

      final result = await datasource.getUser();

      expect(result.data.email, 'budi@example.com');
      expect(result.data.role, UserRole.ownerCompany);
    });

    /// R7 | Branch: ApiException propagation
    /// Expected: ApiException propagates
    test('R7: propagates ApiException from getUser', () async {
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(403, 'Forbidden'));

      await expectLater(
        () async => datasource.getUser(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // userRegistration  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('userRegistration —', () {
    final registrationModel = UserRegistrationModel(
      name: 'Budi',
      email: 'budi@example.com',
      role: UserRole.staffCompany,
      password: 'secret123',
    );

    /// R8 | Branch: happy path
    /// Expected: completes normally, returns void
    test('R8: completes without exception on success', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => <String, dynamic>{});

      await expectLater(
        () async => datasource.userRegistration(registrationModel),
        returnsNormally,
      );
    });

    /// R9 | Argument verification
    /// Expected: post called with Endpoints.register and correct JSON body
    test('R9: posts to Endpoints.register with correct JSON body', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => <String, dynamic>{});

      await datasource.userRegistration(registrationModel);

      verify(() => mockApiClient.post(
            Endpoints.register,
            data: {
              'name': 'Budi',
              'email': 'budi@example.com',
              'role': 'staff_company',
              'password': 'secret123',
            },
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // companyRegistration  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('companyRegistration —', () {
    final companyModel = CompanyRegistrationModel(
      name: 'Andi',
      email: 'andi@corp.com',
      password: 'pass456',
      companyName: 'PT Maju',
    );

    /// R10 | Branch: happy path
    /// Expected: completes normally
    test('R10: completes without exception on success', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => <String, dynamic>{});

      await expectLater(
        () async => datasource.companyRegistration(companyModel),
        returnsNormally,
      );
    });

    /// R11 | Argument verification
    /// Expected: post called with Endpoints.registerCompany and correct JSON body
    test('R11: posts to Endpoints.registerCompany with correct JSON body',
        () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => <String, dynamic>{});

      await datasource.companyRegistration(companyModel);

      verify(() => mockApiClient.post(
            Endpoints.registerCompany,
            data: {
              'name': 'Andi',
              'email': 'andi@corp.com',
              'password': 'pass456',
              'companyName': 'PT Maju',
            },
          )).called(1);
    });
  });
}
