import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/storage/token_storage.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/data/model/logout_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/auth/data/model/user_registration_model.dart';
import 'package:workorder_company_app/features/auth/data/model/company_registration_model.dart';
import 'package:workorder_company_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:workorder_company_app/features/auth/domain/entities/company_registration_entity.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_registration_entity.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}
class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}
class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockAuthRemoteDatasource mockRemote;
  late MockAuthLocalDatasource mockLocal;
  late MockTokenStorage mockTokenStorage;
  late AuthRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const UserModel(
      userId: 'fallback',
      name: 'F',
      email: 'f@f.com',
      role: UserRole.client,
    ));
    registerFallbackValue(UserRegistrationModel(
      name: 'F',
      email: 'f@f.com',
      role: UserRole.client,
      password: 'p',
    ));
    registerFallbackValue(CompanyRegistrationModel(
      name: 'F',
      email: 'f@f.com',
      password: 'p',
      companyName: 'FC',
    ));
  });

  setUp(() {
    mockRemote = MockAuthRemoteDatasource();
    mockLocal = MockAuthLocalDatasource();
    mockTokenStorage = MockTokenStorage();
    repository = AuthRepositoryImpl(mockRemote, mockLocal, mockTokenStorage);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  UserModel makeUserModel() => const UserModel(
        userId: 'uid-001',
        name: 'Budi',
        email: 'budi@example.com',
        role: UserRole.ownerCompany,
        position: null,
      );

  ApiResponse<LoginResponseModel> makeLoginApiResponse() => ApiResponse(
        message: 'success',
        data: LoginResponseModel(user: makeUserModel(), token: 'jwt-token-abc'),
      );

  ApiResponse<LogoutResponseModel> makeLogoutApiResponse() => ApiResponse(
        message: 'success',
        data: LogoutResponseModel(loggedOut: true),
      );

  ApiResponse<UserModel> makeUserApiResponse() =>
      ApiResponse(message: 'success', data: makeUserModel());

  // ═══════════════════════════════════════════════════════════════════════
  // login  │  Cyclomatic Complexity = 3
  //        │  Paths: try-success | on ApiException | catch generic
  // ═══════════════════════════════════════════════════════════════════════
  group('login —', () {
    /// I1 | Branch: try-success
    /// Expected: Right(LoginResponseModel) with correct token
    test('I1: returns Right(LoginResponseModel) on success', () async {
      when(() => mockRemote.login(any(), any()))
          .thenAnswer((_) async => makeLoginApiResponse());

      final result = await repository.login('budi@example.com', 'pass');

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('should be Right'),
          (r) => expect(r.token, 'jwt-token-abc'));
    });

    /// I2 | Branch: on ApiException catch
    /// Expected: Left(ServerFailure) with message from exception
    test('I2: returns Left(ServerFailure) on ApiException', () async {
      when(() => mockRemote.login(any(), any()))
          .thenThrow(ApiException(401, 'Unauthorized'));

      final result = await repository.login('x@x.com', 'wrong');

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) {
          expect(f, isA<ServerFailure>());
          expect(f.message, 'Unauthorized');
        },
        (_) => fail('should be Left'),
      );
    });

    /// I3 | Branch: catch generic
    /// Expected: Left(UnexpectedFailure)
    test('I3: returns Left(UnexpectedFailure) on unexpected exception',
        () async {
      when(() => mockRemote.login(any(), any()))
          .thenThrow(Exception('Network timeout'));

      final result = await repository.login('x@x.com', 'wrong');

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<UnexpectedFailure>()),
        (_) => fail('should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getCurrentUser  │  Cyclomatic Complexity = 7
  //   Paths: refresh=true (remote OK | remote fail+cache | remote fail+local |
  //          remote fail+nothing) | refresh=false (cache | local | none)
  // ═══════════════════════════════════════════════════════════════════════
  group('getCurrentUser —', () {
    /// I4 | Branch: refresh=true, remote success
    /// Expected: Right(remoteUser), local.saveUser called, cache set
    test('I4: refresh=true and remote succeeds → Right(remoteUser)', () async {
      when(() => mockRemote.getUser())
          .thenAnswer((_) async => makeUserApiResponse());
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async {});

      final result = await repository.getCurrentUser(refresh: true);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('should be Right'),
          (u) => expect(u.email, 'budi@example.com'));
      verify(() => mockLocal.saveUser(any())).called(1);
      expect(repository.currentUser, isNotNull);
    });

    /// I5 | Branch: refresh=true, remote fails, memory cache available
    /// Expected: Right(cachedUser), no local call
    test('I5: refresh=true, remote fails, cache hit → Right(cachedUser)',
        () async {
      // Seed memory cache via successful refresh
      when(() => mockRemote.getUser())
          .thenAnswer((_) async => makeUserApiResponse());
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async {});
      await repository.getCurrentUser(refresh: true);

      // Remote now fails
      when(() => mockRemote.getUser()).thenThrow(Exception('Remote error'));

      final result = await repository.getCurrentUser(refresh: true);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('should be Right'),
          (u) => expect(u.email, 'budi@example.com'));
    });

    /// I6 | Branch: refresh=true, remote fails, no cache, local has user
    /// Expected: Right(localUser), cache updated
    test(
        'I6: refresh=true, remote fails, no cache, local has data → Right(localUser)',
        () async {
      when(() => mockRemote.getUser()).thenThrow(Exception('Remote error'));
      when(() => mockLocal.getUser()).thenAnswer((_) async => makeUserModel());

      final result = await repository.getCurrentUser(refresh: true);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('should be Right'),
          (u) => expect(u.email, 'budi@example.com'));
      expect(repository.currentUser, isNotNull);
    });

    /// I7 | Branch: refresh=true, all fallbacks exhausted
    /// Expected: Left(ServerFailure)
    test('I7: refresh=true, all fallbacks exhausted → Left(ServerFailure)',
        () async {
      when(() => mockRemote.getUser()).thenThrow(Exception('Remote error'));
      when(() => mockLocal.getUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser(refresh: true);

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('should be Left'),
      );
    });

    /// I8 | Branch: refresh=false, memory cache hit
    /// Expected: Right(cache), no remote/local calls
    test(
        'I8: refresh=false, cache hit → Right(cache) without hitting remote/local',
        () async {
      // Seed cache
      when(() => mockRemote.getUser())
          .thenAnswer((_) async => makeUserApiResponse());
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async {});
      await repository.getCurrentUser(refresh: true);

      clearInteractions(mockRemote);
      clearInteractions(mockLocal);

      final result = await repository.getCurrentUser();

      expect(result.isRight(), isTrue);
      verifyNever(() => mockRemote.getUser());
      verifyNever(() => mockLocal.getUser());
    });

    /// I9 | Branch: refresh=false, no cache, local has user
    /// Expected: Right(localUser), cache updated
    test('I9: refresh=false, no cache, local hit → Right(localUser)', () async {
      when(() => mockLocal.getUser()).thenAnswer((_) async => makeUserModel());

      final result = await repository.getCurrentUser();

      expect(result.isRight(), isTrue);
      expect(repository.currentUser, isNotNull);
    });

    /// I10 | Branch: refresh=false, no cache, no local
    /// Expected: Left(AuthFailure)
    test('I10: refresh=false, no cache, no local → Left(AuthFailure)',
        () async {
      when(() => mockLocal.getUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // saveUser  │  Cyclomatic Complexity = 2
  //           │  Paths: try-success | catch
  // ═══════════════════════════════════════════════════════════════════════
  group('saveUser —', () {
    /// I11 | Branch: try-success
    /// Expected: Right(null), _cache updated
    test('I11: returns Right(null) and updates cache on success', () async {
      final user = makeUserModel();
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async {});

      final result = await repository.saveUser(user);

      expect(result, const Right(null));
      expect(repository.currentUser, user);
    });

    /// I12 | Branch: catch
    /// Expected: Left(CacheFailure)
    test('I12: returns Left(CacheFailure) when local throws', () async {
      when(() => mockLocal.saveUser(any())).thenThrow(Exception('Disk full'));

      final result = await repository.saveUser(makeUserModel());

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // logOut  │  Cyclomatic Complexity = 3
  //         │  Paths: inner catch (remote swallowed) | outer try-success | outer catch
  // ═══════════════════════════════════════════════════════════════════════
  group('logOut —', () {
    /// I13 | Branch: full success path
    /// Expected: Right(null)
    test('I13: returns Right(null) when all steps succeed', () async {
      when(() => mockRemote.logout())
          .thenAnswer((_) async => makeLogoutApiResponse());
      when(() => mockLocal.clearUser()).thenAnswer((_) async {});
      when(() => mockTokenStorage.clearToken()).thenAnswer((_) async {});

      final result = await repository.logOut();

      expect(result, const Right(null));
    });

    /// I14 | Branch: inner catch swallows remote error
    /// Expected: Right(null) – remote error is silently swallowed
    test('I14: swallows remote logout error and returns Right(null)', () async {
      when(() => mockRemote.logout()).thenThrow(Exception('Remote timeout'));
      when(() => mockLocal.clearUser()).thenAnswer((_) async {});
      when(() => mockTokenStorage.clearToken()).thenAnswer((_) async {});

      final result = await repository.logOut();

      expect(result, const Right(null));
      verify(() => mockLocal.clearUser()).called(1);
      verify(() => mockTokenStorage.clearToken()).called(1);
    });

    /// I15 | Branch: outer catch – clearUser throws
    /// Expected: Left(CacheFailure) with hardcoded message
    test('I15: returns Left(CacheFailure) when clearUser throws', () async {
      when(() => mockRemote.logout())
          .thenAnswer((_) async => makeLogoutApiResponse());
      when(() => mockLocal.clearUser()).thenThrow(Exception('Storage error'));

      final result = await repository.logOut();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) {
          expect(f, isA<CacheFailure>());
          expect(f.message, 'Gagal Menghapus Data Local');
        },
        (_) => fail('should be Left'),
      );
    });

    /// I16 | Branch: outer catch – clearToken throws
    /// Expected: Left(CacheFailure)
    test('I16: returns Left(CacheFailure) when clearToken throws', () async {
      when(() => mockRemote.logout())
          .thenAnswer((_) async => makeLogoutApiResponse());
      when(() => mockLocal.clearUser()).thenAnswer((_) async {});
      when(() => mockTokenStorage.clearToken())
          .thenThrow(Exception('Token error'));

      final result = await repository.logOut();

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<CacheFailure>()),
        (_) => fail('should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // userRegistration  │  Cyclomatic Complexity = 1 (safeCall wraps)
  // ═══════════════════════════════════════════════════════════════════════
  group('userRegistration —', () {
    final entity = UserRegistrationEntity(
      name: 'Citra',
      email: 'citra@corp.com',
      role: UserRole.staffCompany,
      password: 'pass789',
    );

    /// I17 | Branch: success
    /// Expected: Right(null)
    test('I17: returns Right(null) on success', () async {
      when(() => mockRemote.userRegistration(any())).thenAnswer((_) async {});

      final result = await repository.userRegistration(entity);

      expect(result.isRight(), isTrue);
    });

    /// I18 | Branch: remote throws (caught by safeCall)
    /// Expected: Left(...)
    test('I18: returns Left on remote ApiException', () async {
      when(() => mockRemote.userRegistration(any()))
          .thenThrow(ApiException(422, 'Validation error'));

      final result = await repository.userRegistration(entity);

      expect(result.isLeft(), isTrue);
    });

    /// I19 | Argument verification
    /// Expected: remote receives correct UserRegistrationModel fields
    test('I19: passes correct UserRegistrationModel to remote datasource',
        () async {
      when(() => mockRemote.userRegistration(any())).thenAnswer((_) async {});

      await repository.userRegistration(entity);

      final captured =
          verify(() => mockRemote.userRegistration(captureAny())).captured;
      final model = captured.first as UserRegistrationModel;
      expect(model.name, 'Citra');
      expect(model.email, 'citra@corp.com');
      expect(model.role, UserRole.staffCompany);
      expect(model.password, 'pass789');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // companyRegistration  │  Cyclomatic Complexity = 1 (safeCall wraps)
  // ═══════════════════════════════════════════════════════════════════════
  group('companyRegistration —', () {
    final entity = CompanyRegistrationEntity(
      name: 'Doni',
      email: 'doni@corp.com',
      password: 'corp123',
      companyName: 'PT Sukses',
    );

    /// I20 | Branch: success
    /// Expected: Right(null)
    test('I20: returns Right(null) on success', () async {
      when(() => mockRemote.companyRegistration(any())).thenAnswer((_) async {});

      final result = await repository.companyRegistration(entity);

      expect(result.isRight(), isTrue);
    });

    /// I21 | Branch: remote throws (caught by safeCall)
    /// Expected: Left(...)
    test('I21: returns Left on remote ApiException', () async {
      when(() => mockRemote.companyRegistration(any()))
          .thenThrow(ApiException(409, 'Company already exists'));

      final result = await repository.companyRegistration(entity);

      expect(result.isLeft(), isTrue);
    });

    /// I22 | Argument verification
    /// Expected: remote receives correct CompanyRegistrationModel fields
    test('I22: passes correct CompanyRegistrationModel to remote datasource',
        () async {
      when(() => mockRemote.companyRegistration(any())).thenAnswer((_) async {});

      await repository.companyRegistration(entity);

      final captured =
          verify(() => mockRemote.companyRegistration(captureAny())).captured;
      final model = captured.first as CompanyRegistrationModel;
      expect(model.name, 'Doni');
      expect(model.email, 'doni@corp.com');
      expect(model.password, 'corp123');
      expect(model.companyName, 'PT Sukses');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // clearCache  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('clearCache —', () {
    /// I23 | Branch: straight-line
    /// Expected: currentUser becomes null after call
    test('I23: currentUser is null after clearCache', () async {
      // Seed cache first
      when(() => mockRemote.getUser())
          .thenAnswer((_) async => makeUserApiResponse());
      when(() => mockLocal.saveUser(any())).thenAnswer((_) async {});
      await repository.getCurrentUser(refresh: true);
      expect(repository.currentUser, isNotNull);

      repository.clearCache();

      expect(repository.currentUser, isNull);
    });
  });
}
