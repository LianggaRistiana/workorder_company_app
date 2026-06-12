import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/system_integration/data/model/external_user_model.dart';
import 'package:workorder_company_app/features/system_integration/data/model/provider_integration_data_model.dart';
import 'package:workorder_company_app/features/system_integration/data/model/start_pairing_data_model.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/provider_integration_data_entity.dart';

void main() {
  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  Map<String, dynamic> makeCompanyJson() => {
        '_id': 'comp-123',
        'name': 'Test Company',
        'address': '123 Test St',
        'description': 'Description',
        'isActive': true,
        'isFaqActive': false,
      };

  Map<String, dynamic> makeExternalUserJson() => {
        '_id': 'eu-123',
        'integrationType': 'external_system',
        'externalCustomerEmail': 'external@example.com',
        'externalCustomerName': 'External User',
        'company': makeCompanyJson(),
        'pairedAt': '2026-06-12T03:37:03Z',
      };

  Map<String, dynamic> makeProviderIntegrationDataJson({
    String? integrationType = 'external_system',
  }) =>
      {
        'external_login_url': 'https://login.example.com',
        'external_verify_url': 'https://verify.example.com',
        'secret_key': 'secret-123',
        'external_check_memberships_url': 'https://memberships.example.com',
        'is_integration_active': true,
        if (integrationType != null) 'integration_type': integrationType,
      };

  // ═══════════════════════════════════════════════════════════════════════
  // ExternalUserModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('ExternalUserModel —', () {
    /// M1: fromJson parses valid fields correctly
    test('M1: fromJson parses all fields correctly', () {
      final json = makeExternalUserJson();
      final model = ExternalUserModel.fromJson(json);

      expect(model.id, 'eu-123');
      expect(model.integrationType, IntegrationType.externalSystem);
      expect(model.externalEmail, 'external@example.com');
      expect(model.externalName, 'External User');
      expect(model.company.id, 'comp-123');
      expect(model.pairedAt, DateTime.parse('2026-06-12T03:37:03Z'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ProviderIntegrationDataModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('ProviderIntegrationDataModel —', () {
    /// M2: fromJson parses all fields correctly
    test('M2: fromJson parses all fields correctly', () {
      final json = makeProviderIntegrationDataJson();
      final model = ProviderIntegrationDataModel.fromJson(json);

      expect(model.externalLoginUrl, 'https://login.example.com');
      expect(model.externalVerifyUrl, 'https://verify.example.com');
      expect(model.secretKey, 'secret-123');
      expect(model.externalCheckStatusMembershipsUrl, 'https://memberships.example.com');
      expect(model.isIntegrationActive, isTrue);
      expect(model.integrationType, IntegrationType.externalSystem);
    });

    /// M3: fromJson handles null integration_type with default value
    test('M3: fromJson handles missing integration_type with default externalSystem', () {
      final json = makeProviderIntegrationDataJson(integrationType: null);
      final model = ProviderIntegrationDataModel.fromJson(json);

      expect(model.integrationType, IntegrationType.externalSystem);
    });

    /// M4: fromEntity copies all fields from entity
    test('M4: fromEntity copies all fields from entity correctly', () {
      const entity = ProviderIntegrationDataEntity(
        externalLoginUrl: 'https://login.example.com',
        externalVerifyUrl: 'https://verify.example.com',
        secretKey: 'secret-123',
        externalCheckStatusMembershipsUrl: 'https://memberships.example.com',
        isIntegrationActive: true,
        integrationType: IntegrationType.claimCode,
      );

      final model = ProviderIntegrationDataModel.fromEntity(entity);

      expect(model.externalLoginUrl, entity.externalLoginUrl);
      expect(model.externalVerifyUrl, entity.externalVerifyUrl);
      expect(model.secretKey, entity.secretKey);
      expect(model.externalCheckStatusMembershipsUrl, entity.externalCheckStatusMembershipsUrl);
      expect(model.isIntegrationActive, entity.isIntegrationActive);
      expect(model.integrationType, entity.integrationType);
    });

    /// M5: toJson returns correct map with snake_case enum
    test('M5: toJson returns correct map with snake_case enum', () {
      const model = ProviderIntegrationDataModel(
        externalLoginUrl: 'https://login.example.com',
        externalVerifyUrl: 'https://verify.example.com',
        secretKey: 'secret-123',
        externalCheckStatusMembershipsUrl: 'https://memberships.example.com',
        isIntegrationActive: true,
        integrationType: IntegrationType.claimCode,
      );

      final json = model.toJson();

      expect(json['external_login_url'], 'https://login.example.com');
      expect(json['external_verify_url'], 'https://verify.example.com');
      expect(json['external_check_memberships_url'], 'https://memberships.example.com');
      expect(json['secret_key'], 'secret-123');
      expect(json['is_integration_active'], isTrue);
      expect(json['integration_type'], 'claim_token'); // claimCode toSnakeCase = claim_token
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // StartPairingDataModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('StartPairingDataModel —', () {
    /// M6: fromJson parses redirectUrl correctly
    test('M6: fromJson parses redirect_url correctly', () {
      final json = {'redirect_url': 'https://redirect.example.com'};
      final model = StartPairingDataModel.fromJson(json);

      expect(model.redirectUrl, 'https://redirect.example.com');
    });
  });
}
