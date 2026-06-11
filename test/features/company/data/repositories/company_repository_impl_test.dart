import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_management_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/datasources/public_companies_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/company/data/repositories/internal_company_repository_impl.dart';
import 'package:workorder_company_app/features/company/data/repositories/public_companies_repository_impl.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/meta/public_company_meta.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockCompanyManagementRemoteDatasource extends Mock implements CompanyManagementRemoteDatasource {}
class MockPublicCompaniesRemoteDatasource extends Mock implements PublicCompaniesRemoteDatasource {}

void main() {
  late MockCompanyManagementRemoteDatasource mockManagementRemote;
  late MockPublicCompaniesRemoteDatasource mockPublicRemote;
  late InternalCompanyRepositoryImpl internalRepo;
  late PublicCompaniesRepositoryImpl publicRepo;

  setUpAll(() {
    registerFallbackValue(CompanyModel(
      id: 'co-001',
      name: 'PT Maju Bersama',
      address: 'Jl. Sudirman No.1',
      description: 'Perusahaan logistik',
      isActive: true,
      isFaqActive: false,
    ));
  });

  setUp(() {
    mockManagementRemote = MockCompanyManagementRemoteDatasource();
    mockPublicRemote = MockPublicCompaniesRemoteDatasource();
    internalRepo = InternalCompanyRepositoryImpl(mockManagementRemote);
    publicRepo = PublicCompaniesRepositoryImpl(mockPublicRemote);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  CompanyModel makeCompany() => CompanyModel(
        id: 'co-001',
        name: 'PT Maju Bersama',
        address: 'Jl. Sudirman No.1',
        description: 'Perusahaan logistik',
        isActive: true,
        isFaqActive: false,
      );

  ApiResponse<CompanyModel> makeCompanyResponse() => ApiResponse(
        message: 'OK',
        data: makeCompany(),
      );

  ApiResponse<List<CompanyModel>> makeCompanyListResponse() => ApiResponse(
        message: 'OK',
        data: [makeCompany()],
      );

  ApiResponseWithMeta<CompanyModel> makeCompanyWithMetaResponse() => ApiResponseWithMeta(
        message: 'OK',
        data: makeCompany(),
        meta: {
          'isSubscribed': true,
          'isIntegrationActive': false,
        },
      );

  // ═══════════════════════════════════════════════════════════════════════
  // getCompanyInformation  │  Cyclomatic Complexity = 3
  //                        │  Paths: [A] forceRefresh=false & cache valid & cache.value != null -> Right(cached)
  //                        │         [B] forceRefresh=false & cache not valid -> remote -> Right(data), cache updated
  //                        │         [C] forceRefresh=true -> remote -> Right(data), cache updated
  //                        │         [D] remote fails -> Left(Failure)
  // ═══════════════════════════════════════════════════════════════════════
  group('InternalCompanyRepositoryImpl.getCompanyInformation —', () {
    /// I1 | Branch: [A] forceRefresh=false, cache is valid
    /// Expected: Right(cached) is returned and remote is NOT called
    test('I1: returns Right(cached) and does not call remote when cache is valid and forceRefresh is false', () async {
      // Seed the cache first
      when(() => mockManagementRemote.getCompanyInformation())
          .thenAnswer((_) async => makeCompanyResponse());
      await internalRepo.getCompanyInformation(forceRefresh: false);
      verify(() => mockManagementRemote.getCompanyInformation()).called(1);
      clearInteractions(mockManagementRemote);

      // Call again without force refresh
      final result = await internalRepo.getCompanyInformation(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, 'co-001'),
      );
      verifyNever(() => mockManagementRemote.getCompanyInformation());
    });

    /// I2 | Branch: [B] forceRefresh=false, cache empty/invalid
    /// Expected: remote is called, Right(companyData) returned, cache updated
    test('I2: calls remote, returns Right(data), and updates cache when cache is empty', () async {
      when(() => mockManagementRemote.getCompanyInformation())
          .thenAnswer((_) async => makeCompanyResponse());

      final result = await internalRepo.getCompanyInformation(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, 'co-001'),
      );
      verify(() => mockManagementRemote.getCompanyInformation()).called(1);
    });

    /// I3 | Branch: [C] forceRefresh=true, cache pre-seeded
    /// Expected: remote is called and Right(freshData) is returned
    test('I3: calls remote even if cache is seeded when forceRefresh is true', () async {
      // Seed the cache
      when(() => mockManagementRemote.getCompanyInformation())
          .thenAnswer((_) async => makeCompanyResponse());
      await internalRepo.getCompanyInformation(forceRefresh: false);
      verify(() => mockManagementRemote.getCompanyInformation()).called(1);
      clearInteractions(mockManagementRemote);

      // Fetch with force refresh
      final freshCompany = CompanyModel(
        id: 'co-001',
        name: 'PT Maju Bersama Fresh',
        address: 'Jl. Sudirman No.2',
        isActive: true,
        isFaqActive: false,
      );
      when(() => mockManagementRemote.getCompanyInformation())
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: freshCompany));

      final result = await internalRepo.getCompanyInformation(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.id, 'co-001');
          expect(r.name, 'PT Maju Bersama Fresh');
        },
      );
      verify(() => mockManagementRemote.getCompanyInformation()).called(1);
    });

    /// I4 | Branch: [D] remote fails (forceRefresh=false)
    /// Expected: Left(ServerFailure) on remote ApiException
    test('I4: returns Left(ServerFailure) when remote fails and forceRefresh is false', () async {
      when(() => mockManagementRemote.getCompanyInformation())
          .thenThrow(ApiException(404, 'Company not found'));

      final result = await internalRepo.getCompanyInformation(forceRefresh: false);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Company not found');
        },
        (r) => fail('Should be Left'),
      );
    });

    /// I5 | Branch: [D] remote fails (forceRefresh=true)
    /// Expected: Left(ServerFailure) on remote ApiException
    test('I5: returns Left(ServerFailure) when remote fails and forceRefresh is true', () async {
      when(() => mockManagementRemote.getCompanyInformation())
          .thenThrow(ApiException(500, 'Internal Server Error'));

      final result = await internalRepo.getCompanyInformation(forceRefresh: true);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) {
          expect(l, isA<ServerFailure>());
          expect(l.message, 'Server Sedang Gangguan');
        },
        (r) => fail('Should be Left'),
      );
    });

    /// I6 | Branch: Cache update confirmation
    /// Expected: after successful remote call, subsequent call hits cache
    test('I6: subsequent call uses cached resource after success', () async {
      when(() => mockManagementRemote.getCompanyInformation())
          .thenAnswer((_) async => makeCompanyResponse());

      // First call (remote fetch & cache update)
      await internalRepo.getCompanyInformation();
      verify(() => mockManagementRemote.getCompanyInformation()).called(1);
      clearInteractions(mockManagementRemote);

      // Second call (cache hit)
      final result = await internalRepo.getCompanyInformation();
      expect(result.isRight(), isTrue);
      verifyNever(() => mockManagementRemote.getCompanyInformation());
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // updateCompanyInformation  │  Cyclomatic Complexity = 1
  //                           │  Paths: success | remote throws | entity serialization mapping
  // ═══════════════════════════════════════════════════════════════════════
  group('InternalCompanyRepositoryImpl.updateCompanyInformation —', () {
    final entityToUpdate = CompanyEntity(
      id: 'co-001',
      name: 'PT Maju Bersama Baru',
      address: 'Jl. Sudirman No.2',
      description: 'Perusahaan logistik baru',
      isActive: true,
      isFaqActive: true,
    );

    /// I7 | Branch: success
    /// Expected: returns Right(CompanyEntity) and updates internal cache
    test('I7: returns Right(CompanyEntity) and updates cache on success', () async {
      when(() => mockManagementRemote.updateCompanyInformation(any()))
          .thenAnswer((_) async => makeCompanyResponse());

      final result = await internalRepo.updateCompanyInformation(entityToUpdate);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.id, 'co-001'),
      );

      // Verify that cache is indeed updated by making a get call without remote stub (should cache hit)
      clearInteractions(mockManagementRemote);
      final cacheResult = await internalRepo.getCompanyInformation(forceRefresh: false);
      expect(cacheResult.isRight(), isTrue);
      verifyNever(() => mockManagementRemote.getCompanyInformation());
    });

    /// I8 | Branch: remote throws
    /// Expected: returns Left(ServerFailure)
    test('I8: returns Left(ServerFailure) when remote update fails', () async {
      when(() => mockManagementRemote.updateCompanyInformation(any()))
          .thenThrow(ApiException(404, 'Not found'));

      final result = await internalRepo.updateCompanyInformation(entityToUpdate);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('Should be Left'),
      );
    });

    /// I9 | Branch: entity mapping verification
    /// Expected: remote is called with CompanyModel correctly mapped from CompanyEntity
    test('I9: calls remote update with correctly serialized CompanyModel mapped from CompanyEntity', () async {
      when(() => mockManagementRemote.updateCompanyInformation(any()))
          .thenAnswer((_) async => makeCompanyResponse());

      await internalRepo.updateCompanyInformation(entityToUpdate);

      final captured = verify(() => mockManagementRemote.updateCompanyInformation(captureAny())).captured;
      expect(captured.length, 1);
      final model = captured.first as CompanyModel;
      expect(model.id, entityToUpdate.id);
      expect(model.name, entityToUpdate.name);
      expect(model.address, entityToUpdate.address);
      expect(model.description, entityToUpdate.description);
      expect(model.isActive, entityToUpdate.isActive);
      expect(model.isFaqActive, entityToUpdate.isFaqActive);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // clearCache  │  Cyclomatic Complexity = 1
  //             │  Paths: clear cache side effects
  // ═══════════════════════════════════════════════════════════════════════
  group('InternalCompanyRepositoryImpl.clearCache —', () {
    /// I10 | Branch: happy path
    /// Expected: after clearCache, next getCompanyInformation forces a remote call
    test('I10: clearing cache causes subsequent fetch to hit remote datasource', () async {
      when(() => mockManagementRemote.getCompanyInformation())
          .thenAnswer((_) async => makeCompanyResponse());

      // Seed the cache
      await internalRepo.getCompanyInformation();
      verify(() => mockManagementRemote.getCompanyInformation()).called(1);
      clearInteractions(mockManagementRemote);

      // Clear the cache
      internalRepo.clearCache();

      // Fetch again
      await internalRepo.getCompanyInformation();
      verify(() => mockManagementRemote.getCompanyInformation()).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getCompanies  │  Cyclomatic Complexity = 1
  //               │  Paths: success | remote throws
  // ═══════════════════════════════════════════════════════════════════════
  group('PublicCompaniesRepositoryImpl.getCompanies —', () {
    /// I11 | Branch: success
    /// Expected: returns Right(List<CompanyEntity>)
    test('I11: returns Right(List<CompanyEntity>) on remote success', () async {
      when(() => mockPublicRemote.getCompanies())
          .thenAnswer((_) async => makeCompanyListResponse());

      final result = await publicRepo.getCompanies();

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r[0].id, 'co-001');
        },
      );
    });

    /// I12 | Branch: remote throws
    /// Expected: returns Left(ServerFailure)
    test('I12: returns Left(ServerFailure) when remote getCompanies fails', () async {
      when(() => mockPublicRemote.getCompanies())
          .thenThrow(ApiException(403, 'Forbidden'));

      final result = await publicRepo.getCompanies();

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<AuthFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getCompanyById  │  Cyclomatic Complexity = 1
  //                 │  Paths: success | remote throws
  // ═══════════════════════════════════════════════════════════════════════
  group('PublicCompaniesRepositoryImpl.getCompanyById —', () {
    final targetId = 'co-001';

    /// I13 | Branch: success
    /// Expected: returns Right(Result<CompanyEntity>) containing data and PublicCompanyMeta
    test('I13: returns Right(Result<CompanyEntity>) with correct data and metadata on success', () async {
      when(() => mockPublicRemote.getCompanyById(any()))
          .thenAnswer((_) async => makeCompanyWithMetaResponse());

      final result = await publicRepo.getCompanyById(targetId);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r, isA<Result<CompanyEntity>>());
          expect(r.data.id, 'co-001');
          final meta = r.getMeta<PublicCompanyMeta>();
          expect(meta, isNotNull);
          expect(meta!.isSubcribbed, isTrue);
          expect(meta.isIntegrationActive, isFalse);
        },
      );
      verify(() => mockPublicRemote.getCompanyById(targetId)).called(1);
    });

    /// I14 | Branch: remote throws
    /// Expected: returns Left(ServerFailure)
    test('I14: returns Left(ServerFailure) when remote getCompanyById fails', () async {
      when(() => mockPublicRemote.getCompanyById(any()))
          .thenThrow(ApiException(404, 'Not found'));

      final result = await publicRepo.getCompanyById(targetId);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });
}
