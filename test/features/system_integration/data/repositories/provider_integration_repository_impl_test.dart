import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/provider_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/data/model/provider_integration_data_model.dart';
import 'package:workorder_company_app/features/system_integration/data/repositories/provider_integration_repository_impl.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockProviderIntegrationRemoteDatasource extends Mock
    implements ProviderIntegrationRemoteDatasource {}

void main() {
  late MockProviderIntegrationRemoteDatasource mockRemote;
  late ProviderIntegrationRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const ProviderIntegrationDataModel(
      externalLoginUrl: '',
      externalVerifyUrl: '',
      secretKey: '',
      externalCheckStatusMembershipsUrl: '',
      isIntegrationActive: false,
      integrationType: IntegrationType.externalSystem,
    ));
  });

  setUp(() {
    mockRemote = MockProviderIntegrationRemoteDatasource();
    repository = ProviderIntegrationRepositoryImpl(mockRemote);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  ProviderIntegrationDataModel makeModel() => const ProviderIntegrationDataModel(
        externalLoginUrl: 'https://login.example.com',
        externalVerifyUrl: 'https://verify.example.com',
        secretKey: 'secret-123',
        externalCheckStatusMembershipsUrl: 'https://memberships.example.com',
        isIntegrationActive: true,
        integrationType: IntegrationType.externalSystem,
      );

  ApiResponse<ProviderIntegrationDataModel> makeResponse(ProviderIntegrationDataModel data) => ApiResponse(
        message: 'success',
        data: data,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // getProviderIntegrationData  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getProviderIntegrationData —', () {
    test('I11: returns Right(ProviderIntegrationDataEntity) on success', () async {
      when(() => mockRemote.getProviderIntegrationData())
          .thenAnswer((_) async => makeResponse(makeModel()));

      final result = await repository.getProviderIntegrationData();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('should succeed'),
        (r) => expect(r.secretKey, 'secret-123'),
      );
    });

    test('I12: returns Left(ServerFailure) when remote datasource fails', () async {
      when(() => mockRemote.getProviderIntegrationData())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getProviderIntegrationData();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (r) => fail('should fail'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updateProviderIntegrationData  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('updateProviderIntegrationData —', () {
    final entity = makeModel(); // is a ProviderIntegrationDataEntity

    test('I13: returns Right(ProviderIntegrationDataEntity) on success', () async {
      when(() => mockRemote.updateProviderIntegrationData(any()))
          .thenAnswer((_) async => makeResponse(makeModel()));

      final result = await repository.updateProviderIntegrationData(entity);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('should succeed'),
        (r) => expect(r.secretKey, 'secret-123'),
      );
    });

    test('I14: returns Left(ServerFailure) when remote datasource fails', () async {
      when(() => mockRemote.updateProviderIntegrationData(any()))
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.updateProviderIntegrationData(entity);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (r) => fail('should fail'),
      );
    });
  });
}
