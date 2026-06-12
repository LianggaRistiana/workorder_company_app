import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/customer_account_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/data/model/external_user_model.dart';
import 'package:workorder_company_app/features/system_integration/data/model/start_pairing_data_model.dart';
import 'package:workorder_company_app/features/system_integration/data/repositories/customer_account_integration_repository_impl.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockCustomerAccountIntegrationRemoteDatasource extends Mock
    implements CustomerAccountIntegrationRemoteDatasource {}

void main() {
  late MockCustomerAccountIntegrationRemoteDatasource mockRemote;
  late CustomerAccountIntegrationRepositoryImpl repository;

  setUp(() {
    mockRemote = MockCustomerAccountIntegrationRemoteDatasource();
    repository = CustomerAccountIntegrationRepositoryImpl(mockRemote);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  CompanyModel makeCompany() => CompanyModel(
        id: 'comp-123',
        name: 'Test Company',
        address: '123 Test St',
        description: 'Description',
        isActive: true,
        isFaqActive: false,
      );

  ExternalUserModel makeExternalUserModel({String id = 'eu-123'}) => ExternalUserModel(
        id: id,
        integrationType: IntegrationType.externalSystem,
        externalEmail: 'external@example.com',
        externalName: 'External User',
        company: makeCompany(),
        pairedAt: DateTime(2026, 6, 12),
      );

  StartPairingDataModel makeStartPairingDataModel() => const StartPairingDataModel(
        redirectUrl: 'https://redirect.example.com',
      );

  ApiResponse<T> makeResponse<T>(T data) => ApiResponse(
        message: 'success',
        data: data,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // startPairing  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('startPairing —', () {
    const companyId = 'comp-123';

    test('I1: returns Right(StartPairingDataEntity) on success', () async {
      when(() => mockRemote.startPairing(companyId))
          .thenAnswer((_) async => makeResponse(makeStartPairingDataModel()));

      final result = await repository.startPairing(companyId);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('should succeed'),
        (r) => expect(r.redirectUrl, 'https://redirect.example.com'),
      );
    });

    test('I2: returns Left(ServerFailure) when remote datasource fails', () async {
      when(() => mockRemote.startPairing(companyId))
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.startPairing(companyId);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (r) => fail('should fail'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // completePairing  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('completePairing —', () {
    const companyId = 'comp-123';
    const code = 'code-123';
    const state = 'state-xyz';

    test('I3: returns Right(ExternalUserEntity) on success', () async {
      when(() => mockRemote.completePairing(
            companyId: companyId,
            code: code,
            state: state,
          )).thenAnswer((_) async => makeResponse(makeExternalUserModel()));

      final result = await repository.completePairing(
        companyId: companyId,
        code: code,
        state: state,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('should succeed'),
        (r) => expect(r.id, 'eu-123'),
      );
    });

    test('I4: returns Left(ServerFailure) when remote datasource fails', () async {
      when(() => mockRemote.completePairing(
            companyId: companyId,
            code: code,
            state: state,
          )).thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.completePairing(
        companyId: companyId,
        code: code,
        state: state,
      );

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getAccountPairingStatus  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getAccountPairingStatus —', () {
    const companyId = 'comp-123';

    test('I5: returns Right(ExternalUserEntity) on success', () async {
      when(() => mockRemote.getAccountPairingStatus(companyId))
          .thenAnswer((_) async => makeResponse(makeExternalUserModel()));

      final result = await repository.getAccountPairingStatus(companyId);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('should succeed'),
        (r) => expect(r.id, 'eu-123'),
      );
    });

    test('I6: returns Left(ServerFailure) when remote datasource fails', () async {
      when(() => mockRemote.getAccountPairingStatus(companyId))
          .thenThrow(ApiException(404, 'Not Found'));

      final result = await repository.getAccountPairingStatus(companyId);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // detachAccountPairing  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('detachAccountPairing —', () {
    const companyId = 'comp-123';

    test('I7: returns Right(ExternalUserEntity) on success', () async {
      when(() => mockRemote.detachAccountPairing(companyId))
          .thenAnswer((_) async => makeResponse(makeExternalUserModel()));

      final result = await repository.detachAccountPairing(companyId);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('should succeed'),
        (r) => expect(r.id, 'eu-123'),
      );
    });

    test('I8: returns Left(ServerFailure) when remote datasource fails', () async {
      when(() => mockRemote.detachAccountPairing(companyId))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.detachAccountPairing(companyId);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getAllAccountsPairingStatus  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getAllAccountsPairingStatus —', () {
    test('I9: returns Right(List<ExternalUserEntity>) on success', () async {
      when(() => mockRemote.getAllAccountsPairingStatus())
          .thenAnswer((_) async => makeResponse([
                makeExternalUserModel(id: 'eu-1'),
                makeExternalUserModel(id: 'eu-2'),
              ]));

      final result = await repository.getAllAccountsPairingStatus();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('should succeed'),
        (r) {
          expect(r.length, 2);
          expect(r[0].id, 'eu-1');
          expect(r[1].id, 'eu-2');
        },
      );
    });

    test('I10: returns Left(ServerFailure) when remote datasource fails', () async {
      when(() => mockRemote.getAllAccountsPairingStatus())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getAllAccountsPairingStatus();

      expect(result.isLeft(), isTrue);
    });
  });
}
