import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════
  // CompanyModel.fromJson  │  Cyclomatic Complexity = 1 (no logical branching)
  //                        │  Paths: parsing success and fallback defaults
  // ═══════════════════════════════════════════════════════════════════════
  group('CompanyModel.fromJson —', () {
    /// M1 | Branch: happy path, all fields provided
    /// Expected: CompanyModel is instantiated with correct values
    test('M1: fromJson maps all fields correctly when all are provided', () {
      final json = {
        '_id': 'co-001',
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': 'Perusahaan logistik',
        'isActive': true,
        'isFaqActive': true,
      };

      final model = CompanyModel.fromJson(json);

      expect(model.id, 'co-001');
      expect(model.name, 'PT Maju Bersama');
      expect(model.address, 'Jl. Sudirman No.1');
      expect(model.description, 'Perusahaan logistik');
      expect(model.isActive, isTrue);
      expect(model.isFaqActive, isTrue);
    });

    /// M2 | Branch: null address fallback
    /// Expected: address defaults to empty string ""
    test('M2: fromJson uses empty string default when address is null', () {
      final json = {
        '_id': 'co-001',
        'name': 'PT Maju Bersama',
        'address': null,
        'description': 'Perusahaan logistik',
        'isActive': true,
        'isFaqActive': true,
      };

      final model = CompanyModel.fromJson(json);

      expect(model.address, "");
    });

    /// M3 | Branch: null description fallback
    /// Expected: description defaults to empty string ""
    test('M3: fromJson uses empty string default when description is null', () {
      final json = {
        '_id': 'co-001',
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': null,
        'isActive': true,
        'isFaqActive': true,
      };

      final model = CompanyModel.fromJson(json);

      expect(model.description, "");
    });

    /// M4 | Branch: null isActive fallback
    /// Expected: isActive defaults to true
    test('M4: fromJson uses true default when isActive is null', () {
      final json = {
        '_id': 'co-001',
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': 'Perusahaan logistik',
        'isActive': null,
        'isFaqActive': true,
      };

      final model = CompanyModel.fromJson(json);

      expect(model.isActive, isTrue);
    });

    /// M5 | Branch: null/absent isFaqActive fallback
    /// Expected: isFaqActive defaults to false
    test('M5: fromJson uses false default when isFaqActive is null or absent', () {
      final jsonNull = {
        '_id': 'co-001',
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': 'Perusahaan logistik',
        'isActive': true,
        'isFaqActive': null,
      };
      final jsonAbsent = {
        '_id': 'co-001',
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': 'Perusahaan logistik',
        'isActive': true,
      };

      final modelNull = CompanyModel.fromJson(jsonNull);
      final modelAbsent = CompanyModel.fromJson(jsonAbsent);

      expect(modelNull.isFaqActive, isFalse);
      expect(modelAbsent.isFaqActive, isFalse);
    });

    /// M6 | Branch: explicitly true isFaqActive
    /// Expected: isFaqActive is parsed as true
    test('M6: fromJson parses isFaqActive correctly when explicitly true', () {
      final json = {
        '_id': 'co-001',
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': 'Perusahaan logistik',
        'isActive': true,
        'isFaqActive': true,
      };

      final model = CompanyModel.fromJson(json);

      expect(model.isFaqActive, isTrue);
    });

    /// M7 | Branch: missing _id key
    /// Expected: throws TypeError or CastError
    test('M7: fromJson throws TypeError when _id is missing or null', () {
      final json = {
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': 'Perusahaan logistik',
        'isActive': true,
        'isFaqActive': true,
      };

      expect(() => CompanyModel.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CompanyModel.fromEntity  │  Cyclomatic Complexity = 1
  //                          │  Paths: mappings
  // ═══════════════════════════════════════════════════════════════════════
  group('CompanyModel.fromEntity —', () {
    /// M8 | Branch: happy path, mapping from Entity
    /// Expected: returns CompanyModel with identical values
    test('M8: fromEntity copies all fields from entity correctly', () {
      final entity = CompanyEntity(
        id: 'co-001',
        name: 'PT Maju Bersama',
        address: 'Jl. Sudirman No.1',
        description: 'Perusahaan logistik',
        isActive: true,
        isFaqActive: true,
      );

      final model = CompanyModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.name, entity.name);
      expect(model.address, entity.address);
      expect(model.description, entity.description);
      expect(model.isActive, entity.isActive);
      expect(model.isFaqActive, entity.isFaqActive);
    });

    /// M9 | Branch: default values on entity copied
    /// Expected: preserves default empty strings for address and description
    test('M9: fromEntity preserves empty string defaults from entity', () {
      final entity = CompanyEntity(
        id: 'co-002',
        name: 'PT Minimal',
        isActive: false,
        isFaqActive: false,
      );

      final model = CompanyModel.fromEntity(entity);

      expect(model.address, "");
      expect(model.description, "");
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CompanyModel.toJson  │  Cyclomatic Complexity = 1
  //                      │  Paths: serialization
  // ═══════════════════════════════════════════════════════════════════════
  group('CompanyModel.toJson —', () {
    /// M10 | Branch: serializing to map keys check
    /// Expected: resulting map has exactly the expected 6 keys
    test('M10: toJson output includes all 6 keys', () {
      final model = CompanyModel(
        id: 'co-001',
        name: 'PT Maju Bersama',
        address: 'Jl. Sudirman No.1',
        description: 'Perusahaan logistik',
        isActive: true,
        isFaqActive: true,
      );

      final json = model.toJson();

      expect(json.keys.length, 6);
      expect(json.containsKey('id'), isTrue);
      expect(json.containsKey('name'), isTrue);
      expect(json.containsKey('address'), isTrue);
      expect(json.containsKey('description'), isTrue);
      expect(json.containsKey('isActive'), isTrue);
      expect(json.containsKey('isFaqActive'), isTrue);
    });

    /// M11 | Branch: id key mapping check
    /// Expected: the serialization key is 'id', NOT '_id'
    test('M11: toJson maps model.id to key "id", not "_id"', () {
      final model = CompanyModel(
        id: 'co-001',
        name: 'PT Maju Bersama',
        address: 'Jl. Sudirman No.1',
        description: 'Perusahaan logistik',
        isActive: true,
        isFaqActive: true,
      );

      final json = model.toJson();

      expect(json['id'], 'co-001');
      expect(json.containsKey('_id'), isFalse);
    });

    /// M12 | Branch: fields serialization values check
    /// Expected: toJson values match model fields exactly
    test('M12: toJson values match the model fields exactly', () {
      final model = CompanyModel(
        id: 'co-001',
        name: 'PT Maju Bersama',
        address: 'Jl. Sudirman No.1',
        description: 'Perusahaan logistik',
        isActive: true,
        isFaqActive: true,
      );

      final json = model.toJson();

      expect(json['id'], model.id);
      expect(json['name'], model.name);
      expect(json['address'], model.address);
      expect(json['description'], model.description);
      expect(json['isActive'], model.isActive);
      expect(json['isFaqActive'], model.isFaqActive);
    });
  });
}
