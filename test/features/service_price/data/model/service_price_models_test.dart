import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/service_price/data/model/service_price_model.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';

void main() {
  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  ServiceSummaryModel makeSummaryModel() => const ServiceSummaryModel(
        id: 'srv-123',
        title: 'AC Service',
        description: 'Regular maintenance',
        accessType: ServiceAccessType.public,
        isActive: true,
        price: 150000,
      );

  Map<String, dynamic> summaryJson() => {
        '_id': 'srv-123',
        'title': 'AC Service',
        'description': 'Regular maintenance',
        'accessType': 'public',
        'isActive': true,
        'price': 150000,
      };

  // ═══════════════════════════════════════════════════════════════════════
  // ServicePriceModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('ServicePriceModel —', () {
    /// M1: fromJson parses all fields correctly including nested service summary.
    test('M1: fromJson parses all fields correctly', () {
      final json = {
        '_id': 'sp-123',
        'service': summaryJson(),
        'price': 120000,
      };

      final model = ServicePriceModel.fromJson(json);

      expect(model.id, 'sp-123');
      expect(model.service.id, 'srv-123');
      expect(model.service.title, 'AC Service');
      expect(model.price, 120000);
    });

    /// M2: fromEntity maps all properties correctly.
    test('M2: fromEntity maps all fields correctly', () {
      final entity = ServicePriceEntity(
        id: 'sp-xyz',
        service: makeSummaryModel(),
        price: 200000,
      );

      final model = ServicePriceModel.fromEntity(entity);

      expect(model.id, 'sp-xyz');
      expect(model.service.id, 'srv-123');
      expect(model.price, 200000);
    });

    /// M3: toJson serializes properties correctly.
    test('M3: toJson serializes correctly', () {
      final model = ServicePriceModel(
        id: 'sp-123',
        service: makeSummaryModel(),
        price: 120000,
      );

      final json = model.toJson();

      expect(json, {
        '_id': 'sp-123',
        'serviceId': 'srv-123',
        'price': 120000,
      });
    });
  });
}
