import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/memberships/data/model/member_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_codes_generate_draft_model.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_codes_generate_draft_entity.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // MemberModel
  // ─────────────────────────────────────────────────────────────────────────
  group('MemberModel —', () {
    final externalUserJson = {
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

    final userJson = {
      '_id': 'uid-123',
      'name': 'Budi',
      'email': 'budi@example.com',
      'role': 'client',
      'position': null,
    };

    /// M1: fromJson parses externalUser and client correctly.
    test('M1: fromJson parses externalUser and client correctly', () {
      final json = {
        'externalAccount': externalUserJson,
        'user': userJson,
      };

      final model = MemberModel.fromJson(json);

      expect(model.externalUser, isNotNull);
      expect(model.externalUser.id, 'ext-user-123');
      expect(model.externalUser.externalEmail, 'ext@example.com');
      expect(model.client, isNotNull);
      expect(model.client.userId, 'uid-123');
      expect(model.client.role, UserRole.client);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // MembershipCodeModel
  // ─────────────────────────────────────────────────────────────────────────
  group('MembershipCodeModel —', () {
    /// M2: fromJson parses all fields including claimedAt.
    test('M2: fromJson parses all fields including claimedAt', () {
      final json = {
        '_id': 'code-abc',
        'token': 'TOKEN123',
        'externalCustomerEmail': 'cust@example.com',
        'externalCustomerName': 'Customer Name',
        'claimedAt': '2026-06-12T03:37:03Z',
      };

      final model = MembershipCodeModel.fromJson(json);

      expect(model.id, 'code-abc');
      expect(model.token, 'TOKEN123');
      expect(model.externalCustomerEmail, 'cust@example.com');
      expect(model.externalCustomerName, 'Customer Name');
      expect(model.claimedAt, DateTime.parse('2026-06-12T03:37:03Z'));
    });

    /// M3: fromJson parses successfully when claimedAt is null.
    test('M3: fromJson parses null claimedAt correctly', () {
      final json = {
        '_id': 'code-xyz',
        'token': 'TOKEN456',
        'externalCustomerEmail': 'cust2@example.com',
        'externalCustomerName': 'Customer 2',
        'claimedAt': null,
      };

      final model = MembershipCodeModel.fromJson(json);

      expect(model.claimedAt, isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // MembershipCodesGenerateDraftModel (Deprecated but tested for coverage)
  // ─────────────────────────────────────────────────────────────────────────
  group('MembershipCodesGenerateDraftModel —', () {
    /// M4: toJson maps amount and prefix correctly.
    test('M4: toJson maps fields correctly', () {
      const model = MembershipCodesGenerateDraftModel(amount: 10, prefix: 'PRE');
      final json = model.toJson();

      expect(json, {
        'amount': 10,
        'prefix': 'PRE',
      });
    });

    /// M5: fromEntity maps fields correctly.
    test('M5: fromEntity maps fields correctly', () {
      const entity = MembershipCodesGenerateDraftEntity(amount: 5, prefix: 'TST');
      final model = MembershipCodesGenerateDraftModel.fromEntity(entity);

      expect(model.amount, 5);
      expect(model.prefix, 'TST');
    });
  });
}
