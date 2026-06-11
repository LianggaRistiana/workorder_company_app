import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/employees/data/datasource/employees_remote_datasource.dart';
import 'package:workorder_company_app/features/employees/data/repositories/employees_repository_impl.dart';
import 'package:workorder_company_app/features/employees/domain/meta/employee_detail_meta.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockEmployeesRemoteDatasource extends Mock implements EmployeesRemoteDatasource {}

void main() {
  late MockEmployeesRemoteDatasource mockRemote;
  late EmployeesRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const UserEntity(
      name: 'F',
      email: 'f@f.com',
      role: UserRole.staffCompany,
    ));
  });

  setUp(() {
    mockRemote = MockEmployeesRemoteDatasource();
    repository = EmployeesRepositoryImpl(mockRemote);
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  UserModel makeUserModel({
    required String email,
    required String name,
    PositionEntity? position,
  }) =>
      UserModel(
        userId: 'uid-${email.hashCode}',
        name: name,
        email: email,
        role: UserRole.staffCompany,
        position: position != null
            ? PositionModel(id: position.id, name: position.name)
            : null,
      );

  ApiResponse<List<UserModel>> makeEmployeesResponse(List<UserModel> list) => ApiResponse(
        message: 'OK',
        data: list,
      );

  ApiResponseWithMeta<Empty> makeDetailResponseWithMeta() => ApiResponseWithMeta(
        message: 'OK',
        data: Empty(),
        meta: {'canKick': true},
      );

  // ═══════════════════════════════════════════════════════════════════════
  // getEmployees  │  Cyclomatic Complexity = 5 (due to filtering branches)
  //               │  Paths: [A] forceRefresh=false & cache valid -> Right(cached)
  //               │         [B] forceRefresh=false & cache empty -> remote success -> Right(data)
  //               │         [C] forceRefresh=true -> remote success -> Right(freshData)
  //               │         [D] remote fails -> Left(Failure)
  //               │         [E] params == null -> returns unfiltered
  //               │         [F] params.search filter match
  //               │         [G] params.search filter no match
  //               │         [H] params.positionId filter match
  //               │         [I] params.search & positionId filter combined
  // ═══════════════════════════════════════════════════════════════════════
  group('EmployeesRepositoryImpl.getEmployees —', () {
    /// I1 | Branch: forceRefresh=false, cache valid
    /// Expected: Right(cached) is returned, remote NOT called
    test('I1: returns Right(cached) and does not call remote when cache is valid and forceRefresh is false', () async {
      final user = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user]));

      // Seed cache
      await repository.getEmployees(forceRefresh: false);
      verify(() => mockRemote.getEmployees()).called(1);
      clearInteractions(mockRemote);

      // Call again
      final result = await repository.getEmployees(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r[0].email, 'ahmad@company.com'),
      );
      verifyNever(() => mockRemote.getEmployees());
    });

    /// I2 | Branch: forceRefresh=false, cache empty
    /// Expected: remote called, returns Right(data)
    test('I2: calls remote and returns Right(data) when cache is empty', () async {
      final user = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user]));

      final result = await repository.getEmployees(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r[0].email, 'ahmad@company.com'),
      );
      verify(() => mockRemote.getEmployees()).called(1);
    });

    /// I3 | Branch: forceRefresh=true
    /// Expected: remote is called even if cache is pre-seeded
    test('I3: calls remote even if cache is valid when forceRefresh is true', () async {
      final user = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user]));

      // Seed cache
      await repository.getEmployees(forceRefresh: false);
      verify(() => mockRemote.getEmployees()).called(1);
      clearInteractions(mockRemote);

      // Fetch fresh
      final freshUser = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad Fresh');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([freshUser]));

      final result = await repository.getEmployees(forceRefresh: true);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r[0].name, 'Ahmad Fresh'),
      );
      verify(() => mockRemote.getEmployees()).called(1);
    });

    /// I4 | Branch: remote fails
    /// Expected: returns Left(ServerFailure)
    test('I4: returns Left(ServerFailure) when remote getEmployees fails', () async {
      when(() => mockRemote.getEmployees())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getEmployees(forceRefresh: false);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('Should be Left'),
      );
    });

    /// I5 | Branch: params == null
    /// Expected: returns unfiltered list
    test('I5: returns unfiltered list when params is null', () async {
      final user1 = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad');
      final user2 = makeUserModel(email: 'budi@company.com', name: 'Budi');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user1, user2]));

      final result = await repository.getEmployees(params: null);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.length, 2),
      );
    });

    /// I6 | Branch: params.search filter match
    /// Expected: returns filtered list containing matching employee names
    test('I6: returns filtered list matching the search term case-insensitively', () async {
      final user1 = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad');
      final user2 = makeUserModel(email: 'budi@company.com', name: 'Budi');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user1, user2]));

      final result = await repository.getEmployees(params: const EmployeesParams(search: 'ahm'));

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r[0].name, 'Ahmad');
        },
      );
    });

    /// I7 | Branch: params.search filter no match
    /// Expected: returns empty list
    test('I7: returns empty list when search term does not match any name', () async {
      final user1 = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad');
      final user2 = makeUserModel(email: 'budi@company.com', name: 'Budi');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user1, user2]));

      final result = await repository.getEmployees(params: const EmployeesParams(search: 'zaki'));

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) => expect(r.isEmpty, isTrue),
      );
    });

    /// I8 | Branch: params.positionId filter match
    /// Expected: returns filtered list matching the positionId
    test('I8: returns filtered list matching the positionId', () async {
      final pos1 = const PositionEntity(id: 'pos-1', name: 'Developer');
      final pos2 = const PositionEntity(id: 'pos-2', name: 'Designer');
      final user1 = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad', position: pos1);
      final user2 = makeUserModel(email: 'budi@company.com', name: 'Budi', position: pos2);
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user1, user2]));

      final result = await repository.getEmployees(params: const EmployeesParams(positionId: 'pos-1'));

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r[0].name, 'Ahmad');
        },
      );
    });

    /// I9 | Branch: params.search & positionId filter combined
    /// Expected: returns list matching both criteria
    test('I9: returns filtered list matching both search term and positionId', () async {
      final pos1 = const PositionEntity(id: 'pos-1', name: 'Developer');
      final user1 = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad Developer', position: pos1);
      final user2 = makeUserModel(email: 'budi@company.com', name: 'Ahmad Designer', position: const PositionEntity(id: 'pos-2', name: 'Designer'));
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user1, user2]));

      final result = await repository.getEmployees(params: const EmployeesParams(search: 'ahmad', positionId: 'pos-1'));

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r[0].email, 'ahmad@company.com');
        },
      );
    });

    /// I10 | Branch: cache sequence update
    /// Expected: sequential calls hit cached resource
    test('I10: consecutive calls fetch list from cache after initial Remote success', () async {
      final user = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user]));

      await repository.getEmployees();
      verify(() => mockRemote.getEmployees()).called(1);
      clearInteractions(mockRemote);

      final result = await repository.getEmployees();
      expect(result.isRight(), isTrue);
      verifyNever(() => mockRemote.getEmployees());
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // clearCache  │  Cyclomatic Complexity = 1
  //             │  Paths: clear cache side effects
  // ═══════════════════════════════════════════════════════════════════════
  group('EmployeesRepositoryImpl.clearCache —', () {
    /// I11 | Branch: happy path
    /// Expected: cache is invalidated, next call hits remote
    test('I11: clearCache causes subsequent getEmployees to hit remote datasource', () async {
      final user = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user]));

      // Seed
      await repository.getEmployees();
      verify(() => mockRemote.getEmployees()).called(1);
      clearInteractions(mockRemote);

      // Clear cache
      repository.clearCache();

      // Next call
      await repository.getEmployees();
      verify(() => mockRemote.getEmployees()).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getEmployeeByDetail  │  Cyclomatic Complexity = 1
  //                      │  Paths: success | remote throws
  // ═══════════════════════════════════════════════════════════════════════
  group('EmployeesRepositoryImpl.getEmployeeByDetail —', () {
    final targetId = 'uid-123';

    /// I12 | Branch: success
    /// Expected: returns Right(Result<Empty>) with EmployeeDetailMeta
    test('I12: returns Right(Result<Empty>) on remote success', () async {
      when(() => mockRemote.getEmployeeByDetail(any()))
          .thenAnswer((_) async => makeDetailResponseWithMeta());

      final result = await repository.getEmployeeByDetail(targetId);

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r, isA<Result<Empty>>());
          final meta = r.getMeta<EmployeeDetailMeta>();
          expect(meta, isNotNull);
          expect(meta!.canKick, isTrue);
        },
      );
      verify(() => mockRemote.getEmployeeByDetail(targetId)).called(1);
    });

    /// I13 | Branch: remote throws
    /// Expected: returns Left(ServerFailure)
    test('I13: returns Left(ServerFailure) when remote getEmployeeByDetail fails', () async {
      when(() => mockRemote.getEmployeeByDetail(any()))
          .thenThrow(ApiException(404, 'Employee not found'));

      final result = await repository.getEmployeeByDetail(targetId);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<ServerFailure>()),
        (r) => fail('Should be Left'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // kickEmployee  │  Cyclomatic Complexity = 1
  //               │  Paths: success | remote throws | stream notification
  // ═══════════════════════════════════════════════════════════════════════
  group('EmployeesRepositoryImpl.kickEmployee —', () {
    const kickedUserEntity = UserEntity(
      name: 'Ahmad',
      email: 'ahmad@company.com',
      role: UserRole.staffCompany,
    );

    /// I14 | Branch: success cache invalidation
    /// Expected: returns Right(Empty) and removes user from cache
    test('I14: returns Right(Empty) and removes kicked user from cached employees list', () async {
      // Seed cache with Budy and Ahmad
      final user1 = makeUserModel(email: 'ahmad@company.com', name: 'Ahmad');
      final user2 = makeUserModel(email: 'budi@company.com', name: 'Budi');
      when(() => mockRemote.getEmployees())
          .thenAnswer((_) async => makeEmployeesResponse([user1, user2]));

      await repository.getEmployees();
      verify(() => mockRemote.getEmployees()).called(1);
      clearInteractions(mockRemote);

      // Mock Kick remote success
      when(() => mockRemote.kickEmployee(any()))
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: Empty()));

      final result = await repository.kickEmployee(kickedUserEntity);

      expect(result.isRight(), isTrue);
      verify(() => mockRemote.kickEmployee('ahmad@company.com')).called(1);

      // Verify cached list no longer contains Ahmad
      final getCachedResult = await repository.getEmployees(forceRefresh: false);
      expect(getCachedResult.isRight(), isTrue);
      getCachedResult.fold(
        (l) => fail('Should be Right'),
        (r) {
          expect(r.length, 1);
          expect(r[0].email, 'budi@company.com');
        },
      );
      verifyNever(() => mockRemote.getEmployees());
    });

    /// I15 | Branch: remote throws
    /// Expected: returns Left(ServerFailure)
    test('I15: returns Left(ServerFailure) when remote kick fails', () async {
      when(() => mockRemote.kickEmployee(any()))
          .thenThrow(ApiException(403, 'Forbidden'));

      final result = await repository.kickEmployee(kickedUserEntity);

      expect(result.isLeft(), isTrue);
      result.fold(
        (l) => expect(l, isA<AuthFailure>()),
        (r) => fail('Should be Left'),
      );
    });

    /// I16 | Branch: stream notification
    /// Expected: cacheChanged stream emits event on successful kick
    test('I16: emits event on cacheChanged stream when employee is successfully kicked', () async {
      when(() => mockRemote.kickEmployee(any()))
          .thenAnswer((_) async => ApiResponse(message: 'OK', data: Empty()));

      final expectation = expectLater(repository.cacheChanged, emits(null));

      await repository.kickEmployee(kickedUserEntity);

      await expectation;
    });
  });
}
