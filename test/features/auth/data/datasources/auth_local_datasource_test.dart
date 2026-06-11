import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late AuthLocalDatasourceImpl datasource;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    datasource = AuthLocalDatasourceImpl(secureStorage: mockStorage);
  });

  // ── helpers ────────────────────────────────────────────────────────────
  UserModel makeUser() => const UserModel(
        userId: 'uid-001',
        name: 'Budi Santoso',
        email: 'budi@example.com',
        role: UserRole.ownerCompany,
        position: null,
      );

  Map<String, dynamic> makeUserJson() => {
        '_id': 'uid-001',
        'name': 'Budi Santoso',
        'email': 'budi@example.com',
        'role': 'owner_company',
        'position': null,
      };

  // ═══════════════════════════════════════════════════════════════════════
  // saveUser  │  Cyclomatic Complexity = 1 (no branching)
  // ═══════════════════════════════════════════════════════════════════════
  group('saveUser —', () {
    /// L1 | Branch: straight-line
    /// Expected: secureStorage.write called with key='auth_user' and encoded JSON
    test('L1: saves UserModel – writes encoded JSON to storage', () async {
      when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      await datasource.saveUser(makeUser());

      final captured = verify(
        () => mockStorage.write(
          key: captureAny(named: 'key'),
          value: captureAny(named: 'value'),
        ),
      ).captured;

      expect(captured[0], 'auth_user');
      final decoded = json.decode(captured[1] as String);
      expect(decoded['name'], 'Budi Santoso');
      expect(decoded['email'], 'budi@example.com');
      expect(decoded['role'], 'owner_company');
    });

    /// L2 | Branch: null-position field serialization
    /// Expected: JSON contains position: null
    test('L2: saves UserModel with null position – position key is null in JSON',
        () async {
      when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      await datasource.saveUser(makeUser());

      final captured = verify(
        () => mockStorage.write(
          key: captureAny(named: 'key'),
          value: captureAny(named: 'value'),
        ),
      ).captured;

      final decoded = json.decode(captured[1] as String);
      expect(decoded['position'], isNull);
    });

    /// L3 | Branch: successful cast (UserModel passes as UserEntity)
    /// Expected: no exception thrown
    test('L3: accepts UserModel input without throwing', () async {
      when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      expect(() async => datasource.saveUser(makeUser()), returnsNormally);
    });

    /// L4 | Branch: cast failure path (bare UserEntity, not UserModel)
    /// Expected: throws TypeError at runtime due to `user as UserModel`
    test('L4: throws TypeError when a non-UserModel UserEntity is passed',
        () async {
      // Construct a bare UserEntity (not a UserModel)
      const bareEntity = UserEntity(
        userId: 'uid-999',
        name: 'Ghost',
        email: 'ghost@example.com',
        role: UserRole.client,
      );

      when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      // The internal cast `user as UserModel` will throw
      expect(() async => datasource.saveUser(bareEntity), throwsA(isA<TypeError>()));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getUser  │  Cyclomatic Complexity = 2 (one null-guard branch)
  // ═══════════════════════════════════════════════════════════════════════
  group('getUser —', () {
    /// L5 | Branch: non-null JSON in storage
    /// Expected: returns parsed UserModel
    test('L5: returns UserModel when JSON exists in storage', () async {
      final jsonString = json.encode(makeUserJson());
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => jsonString);

      final result = await datasource.getUser();

      expect(result, isNotNull);
      expect(result!.email, 'budi@example.com');
      expect(result.role, UserRole.ownerCompany);
    });

    /// L6 | Branch: null guard → early return null
    /// Expected: returns null when storage is empty
    test('L6: returns null when storage has no entry', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      final result = await datasource.getUser();

      expect(result, isNull);
    });

    /// L7 | Branch: decode failure (malformed JSON)
    /// Expected: throws FormatException
    test('L7: throws FormatException when stored value is malformed JSON',
        () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => 'NOT_VALID_JSON{{{');

      await expectLater(
        () async => datasource.getUser(),
        throwsA(isA<FormatException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // clearUser  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('clearUser —', () {
    /// L8 | Branch: straight-line
    /// Expected: storage.delete called with 'auth_user'
    test('L8: calls storage.delete with key=auth_user', () async {
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await datasource.clearUser();

      verify(() => mockStorage.delete(key: 'auth_user')).called(1);
    });
  });
}
