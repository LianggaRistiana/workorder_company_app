import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_draft_model.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_model.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_draft_entity.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // InvitationDraftModel
  // ─────────────────────────────────────────────────────────────────────────
  group('InvitationDraftModel —', () {
    final positionJson = {
      '_id': 'pos-123',
      'name': 'Technician',
      'description': 'Field Technician',
      'isActive': true,
    };

    /// M1: fromJson parses email, role, and position correctly.
    test('M1: fromJson parses all fields correctly', () {
      final json = {
        'email': 'staff@example.com',
        'role': 'staff_company',
        'position': positionJson,
      };

      final model = InvitationDraftModel.fromJson(json);

      expect(model.email, 'staff@example.com');
      expect(model.role, UserRole.staffCompany);
      expect(model.position, isNotNull);
      expect(model.position!.id, 'pos-123');
      expect(model.position!.name, 'Technician');
    });

    /// M2: toJson serializes role as snake_case and extracts position id.
    test('M2: toJson serializes correctly', () {
      final model = InvitationDraftModel(
        email: 'staff@example.com',
        role: UserRole.managerCompany,
        position: const PositionModel(id: 'pos-abc', name: 'Manager'),
      );

      final json = model.toJson();

      expect(json, {
        'email': 'staff@example.com',
        'role': 'manager_company',
        'positionId': 'pos-abc',
      });
    });

    /// M3: fromEntity maps all fields correctly.
    test('M3: fromEntity maps fields correctly', () {
      final entity = InvitationDraftEntity(
        email: 'test@example.com',
        role: UserRole.client,
        position: const PositionModel(id: 'pos-client', name: 'Client Support'),
      );

      final model = InvitationDraftModel.fromEntity(entity);

      expect(model.email, 'test@example.com');
      expect(model.role, UserRole.client);
      expect(model.position!.id, 'pos-client');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // InvitationModel
  // ─────────────────────────────────────────────────────────────────────────
  group('InvitationModel —', () {
    final userJson = {
      'name': 'John Doe',
      'email': 'john@example.com',
    };

    final companyJson = {
      '_id': 'comp-999',
      'name': 'PT Jaya Sentosa',
      'address': 'Jl. Sentosa No. 5',
      'isActive': true,
      'isFaqActive': false,
    };

    final positionJson = {
      '_id': 'pos-777',
      'name': 'Staff',
    };

    /// M4: fromJson maps all fields when everything is populated.
    test('M4: fromJson parses all populated fields correctly', () {
      final json = {
        '_id': 'inv-abc-123',
        'role': 'staff_company',
        'status': 'pending',
        'user': userJson,
        'createdAt': '2026-06-12T03:37:03Z',
        'updatedAt': '2026-06-12T03:45:00Z',
        'expiresAt': '2026-06-19T03:37:03Z',
        'company': companyJson,
        'position': positionJson,
      };

      final model = InvitationModel.fromJson(json);

      expect(model.id, 'inv-abc-123');
      expect(model.role, UserRole.staffCompany);
      expect(model.status, InvitationStatus.pending);
      expect(model.toUser, isNotNull);
      expect(model.toUser!.name, 'John Doe');
      expect(model.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
      expect(model.updatedAt, DateTime.parse('2026-06-12T03:45:00Z'));
      expect(model.expiresAt, DateTime.parse('2026-06-19T03:37:03Z'));
      expect(model.company, isNotNull);
      expect(model.company!.name, 'PT Jaya Sentosa');
      expect(model.position, isNotNull);
      expect(model.position!.name, 'Staff');
    });

    /// M5: fromJson maps optional fields to null when they are missing.
    test('M5: fromJson maps missing optional fields to null', () {
      final json = {
        '_id': 'inv-xyz',
        'role': 'client',
        'status': 'accepted',
      };

      final model = InvitationModel.fromJson(json);

      expect(model.id, 'inv-xyz');
      expect(model.role, UserRole.client);
      expect(model.status, InvitationStatus.accepted);
      expect(model.toUser, isNull);
      expect(model.createdAt, isNull);
      expect(model.updatedAt, isNull);
      expect(model.expiresAt, isNull);
      expect(model.company, isNull);
      expect(model.position, isNull);
    });
  });
}
