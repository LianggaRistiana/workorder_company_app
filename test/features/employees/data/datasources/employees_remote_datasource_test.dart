import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/features/employees/data/datasource/employees_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late EmployeesRemoteDatasourceImpl datasource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = EmployeesRemoteDatasourceImpl(mockApiClient);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  Map<String, dynamic> userJson() => {
        '_id': 'uid-123',
        'name': 'Ahmad',
        'email': 'ahmad@company.com',
        'role': 'staff_company',
        'position': null,
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
  // getEmployees  │  Cyclomatic Complexity = 1
  //               │  Paths: happy path | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('EmployeesRemoteDatasourceImpl.getEmployees —', () {
    /// R1 | Branch: happy path
    /// Expected: returns ApiResponse<List<UserModel>> with parsed data
    test('R1: getEmployees returns ApiResponse<List<UserModel>> on success', () async {
      final listData = [userJson()];
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: listData));

      final response = await datasource.getEmployees();

      expect(response, isA<ApiResponse<List<UserModel>>>());
      expect(response.data.length, 1);
      expect(response.data[0].userId, 'uid-123');
      expect(response.data[0].email, 'ahmad@company.com');
    });

    /// R2 | Branch: error propagation
    /// Expected: propagates ApiException thrown by ApiClient
    test('R2: getEmployees propagates ApiException on error', () async {
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(500, 'Server Error'));

      await expectLater(
        () => datasource.getEmployees(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getEmployeeByDetail  │  Cyclomatic Complexity = 1
  //                      │  Paths: happy path | endpoint verification | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('EmployeesRemoteDatasourceImpl.getEmployeeByDetail —', () {
    final targetId = 'uid-123';
    final expectedEndpoint = Endpoints.employees.byId(targetId);

    /// R3 | Branch: happy path
    /// Expected: returns ApiResponseWithMeta<Empty>
    test('R3: getEmployeeByDetail returns ApiResponseWithMeta<Empty> on success', () async {
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseWithMetaJson(data: {}, meta: {'canKick': true}));

      final response = await datasource.getEmployeeByDetail(targetId);

      expect(response, isA<ApiResponseWithMeta<Empty>>());
      expect(response.data, isA<Empty>());
      expect(response.meta?['canKick'], isTrue);
    });

    /// R4 | Branch: endpoint verification
    /// Expected: get is called with correct path Interpolated with ID
    test('R4: getEmployeeByDetail calls API get with correct ID-based endpoint path', () async {
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseWithMetaJson(data: {}, meta: {'canKick': true}));

      await datasource.getEmployeeByDetail(targetId);

      verify(() => mockApiClient.get<dynamic>(
            expectedEndpoint,
          )).called(1);
    });

    /// R5 | Branch: error propagation
    /// Expected: propagates ApiException thrown by ApiClient
    test('R5: getEmployeeByDetail propagates ApiException on error', () async {
      when(() => mockApiClient.get<dynamic>(any(), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(404, 'Employee not found'));

      await expectLater(
        () => datasource.getEmployeeByDetail(targetId),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // kickEmployee  │  Cyclomatic Complexity = 1
  //               │  Paths: happy path | body verification | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('EmployeesRemoteDatasourceImpl.kickEmployee —', () {
    final emailToKick = 'ahmad@company.com';

    /// R6 | Branch: happy path
    /// Expected: returns ApiResponse<Empty>
    test('R6: kickEmployee returns ApiResponse<Empty> on success', () async {
      when(() => mockApiClient.delete<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: {}));

      final response = await datasource.kickEmployee(emailToKick);

      expect(response, isA<ApiResponse<Empty>>());
      expect(response.data, isA<Empty>());
    });

    /// R7 | Branch: body verification
    /// Expected: delete is called with correct endpoint and email body payload
    test('R7: kickEmployee calls API delete with correct endpoint and body payload', () async {
      when(() => mockApiClient.delete<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: {}));

      await datasource.kickEmployee(emailToKick);

      verify(() => mockApiClient.delete<dynamic>(
            Endpoints.employees,
            data: {'email': emailToKick},
          )).called(1);
    });

    /// R8 | Branch: error propagation
    /// Expected: propagates ApiException thrown by ApiClient
    test('R8: kickEmployee propagates ApiException on error', () async {
      when(() => mockApiClient.delete<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(403, 'Permission denied'));

      await expectLater(
        () => datasource.kickEmployee(emailToKick),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
