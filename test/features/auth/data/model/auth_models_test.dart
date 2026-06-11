import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/data/model/login_response.dart';
import 'package:workorder_company_app/features/auth/data/model/logout_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/auth/data/model/company_registration_model.dart';
import 'package:workorder_company_app/features/auth/data/model/user_registration_model.dart';

/// Pure unit tests for data models – no mocks needed.
void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // UserModel.fromJson / toJson
  // ─────────────────────────────────────────────────────────────────────────
  group('UserModel —', () {
    /// M5: fromJson with all fields populated including position.
    test('M5: fromJson maps all fields correctly with position', () {
      final json = {
        '_id': 'uid-001',
        'name': 'Budi Santoso',
        'email': 'budi@example.com',
        'role': 'owner_company',
        'position': {'_id': 'pos-1', 'name': 'Engineer'},
      };

      final user = UserModel.fromJson(json);

      expect(user.userId, 'uid-001');
      expect(user.name, 'Budi Santoso');
      expect(user.email, 'budi@example.com');
      expect(user.role, UserRole.ownerCompany);
      expect(user.position, isNotNull);
      expect(user.position!.name, 'Engineer');
    });

    /// M6: fromJson with null position → position is null.
    test('M6: fromJson with null position → position is null', () {
      final json = {
        '_id': 'uid-002',
        'name': 'Citra',
        'email': 'citra@example.com',
        'role': 'staff_company',
        'position': null,
      };

      final user = UserModel.fromJson(json);

      expect(user.position, isNull);
    });

    /// M7: fromJson correctly parses role enum from snake_case string.
    test('M7: fromJson parses role snake_case string to UserRole enum', () {
      final roles = {
        'owner_company': UserRole.ownerCompany,
        'manager_company': UserRole.managerCompany,
        'staff_company': UserRole.staffCompany,
        'staff_unassigned': UserRole.staffUnassigned,
        'client': UserRole.client,
      };

      for (final entry in roles.entries) {
        final json = {
          'name': 'X',
          'email': 'x@x.com',
          'role': entry.key,
          'position': null,
        };
        final user = UserModel.fromJson(json);
        expect(user.role, entry.value,
            reason: '${entry.key} should map to ${entry.value}');
      }
    });

    /// M8: toJson with null position → position key is null.
    test('M8: toJson encodes null position correctly', () {
      final user = UserModel(
        userId: 'uid-001',
        name: 'Budi',
        email: 'budi@example.com',
        role: UserRole.ownerCompany,
        position: null,
      );

      final json = user.toJson();

      expect(json['name'], 'Budi');
      expect(json['email'], 'budi@example.com');
      expect(json['role'], 'owner_company');
      expect(json['position'], isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // LoginResponseModel.fromJson
  // ─────────────────────────────────────────────────────────────────────────
  group('LoginResponseModel —', () {
    /// M1: Valid JSON maps to correct fields.
    test('M1: fromJson returns model with correct token and user', () {
      final json = {
        'token': 'jwt-abc',
        'user': {
          '_id': 'uid-001',
          'name': 'Budi',
          'email': 'budi@example.com',
          'role': 'owner_company',
          'position': null,
        },
      };

      final model = LoginResponseModel.fromJson(json);

      expect(model.token, 'jwt-abc');
      expect(model.user.email, 'budi@example.com');
    });

    /// M2: Missing token key → throws Null check / TypeError.
    test('M2: fromJson throws when token key is missing', () {
      final json = {
        'user': {
          '_id': 'uid-001',
          'name': 'X',
          'email': 'x@x.com',
          'role': 'client',
          'position': null,
        },
      };

      expect(() => LoginResponseModel.fromJson(json), throwsA(anything));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // LogoutResponseModel.fromJson
  // ─────────────────────────────────────────────────────────────────────────
  group('LogoutResponseModel —', () {
    /// M3: loggedOut: true → model has true.
    test('M3: fromJson maps loggedOut=true correctly', () {
      final model = LogoutResponseModel.fromJson({'loggedOut': true});
      expect(model.loggedOut, isTrue);
    });

    /// M4: loggedOut key absent → defaults to false.
    test('M4: fromJson defaults loggedOut to false when key is absent', () {
      final model = LogoutResponseModel.fromJson({});
      expect(model.loggedOut, isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // UserRegistrationModel.fromEntity / toJson
  // ─────────────────────────────────────────────────────────────────────────
  group('UserRegistrationModel —', () {
    /// M11: fromEntity maps all entity fields to model.
    test('M11: fromEntity maps all fields correctly', () {
      final model = UserRegistrationModel(
        name: 'Eko',
        email: 'eko@corp.com',
        role: UserRole.managerCompany,
        password: 'secret',
      );

      expect(model.name, 'Eko');
      expect(model.email, 'eko@corp.com');
      expect(model.role, UserRole.managerCompany);
      expect(model.password, 'secret');
    });

    /// M12: toJson converts role to snake_case.
    test('M12: toJson converts role enum to snake_case string', () {
      final model = UserRegistrationModel(
        name: 'Eko',
        email: 'eko@corp.com',
        role: UserRole.managerCompany,
        password: 'secret',
      );

      final json = model.toJson();

      expect(json['name'], 'Eko');
      expect(json['role'], 'manager_company');
      expect(json['password'], 'secret');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // CompanyRegistrationModel.fromEntity / toJson
  // ─────────────────────────────────────────────────────────────────────────
  group('CompanyRegistrationModel —', () {
    /// M13: All entity fields mapped correctly.
    test('M13: fields mapped correctly from entity', () {
      final model = CompanyRegistrationModel(
        name: 'Farida',
        email: 'farida@corp.com',
        password: 'corp456',
        companyName: 'PT Jaya',
      );

      expect(model.name, 'Farida');
      expect(model.companyName, 'PT Jaya');
    });

    /// M14: toJson includes companyName key.
    test('M14: toJson includes companyName in JSON output', () {
      final model = CompanyRegistrationModel(
        name: 'Farida',
        email: 'farida@corp.com',
        password: 'corp456',
        companyName: 'PT Jaya',
      );

      final json = model.toJson();

      expect(json.containsKey('companyName'), isTrue);
      expect(json['companyName'], 'PT Jaya');
    });
  });
}
