import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

void main() {
  group('PositionModel —', () {
    /// M1: fromJson parses id, name, description, and isActive correctly.
    test('M1: fromJson parses all fields correctly', () {
      final json = {
        '_id': 'pos-123',
        'name': 'Supervisor',
        'description': 'Works as a supervisor',
        'isActive': false,
      };

      final model = PositionModel.fromJson(json);

      expect(model.id, 'pos-123');
      expect(model.name, 'Supervisor');
      expect(model.description, 'Works as a supervisor');
      expect(model.isActive, isFalse);
    });

    /// M2: fromJsonTemplate generates ID randomly and parses correctly.
    test('M2: fromJsonTemplate generates a random ID and parses other fields', () {
      final json = {
        'name': 'Supervisor',
        'description': 'Works as a supervisor',
        'isActive': null,
      };

      final model = PositionModel.fromJsonTemplate(json);

      expect(model.id, isNotEmpty);
      expect(model.id, isNot('pos-123'));
      expect(model.name, 'Supervisor');
      expect(model.description, 'Works as a supervisor');
      expect(model.isActive, isTrue); // Defaults to true when null
    });

    /// M3: toJson serializes correctly.
    test('M3: toJson serializes correctly', () {
      const model = PositionModel(
        id: 'pos-123',
        name: 'Supervisor',
        description: 'Works as a supervisor',
        isActive: true,
      );

      final json = model.toJson();

      expect(json, {
        '_id': 'pos-123',
        'name': 'Supervisor',
        'description': 'Works as a supervisor',
        'isActive': true,
      });
    });

    /// M4: fromEntity maps fields correctly.
    test('M4: fromEntity maps fields correctly', () {
      const entity = PositionEntity(
        id: 'pos-xyz',
        name: 'Technician',
        description: 'Field Technician',
        isActive: true,
      );

      final model = PositionModel.fromEntity(entity);

      expect(model.id, 'pos-xyz');
      expect(model.name, 'Technician');
      expect(model.description, 'Field Technician');
      expect(model.isActive, isTrue);
    });
  });
}
