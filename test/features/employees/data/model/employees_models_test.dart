import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/features/employees/domain/meta/employee_detail_meta.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════
  // EmployeeDetailMeta.fromJson  │  Cyclomatic Complexity = 1
  //                              │  Paths: parsing success and fallback defaults
  // ═══════════════════════════════════════════════════════════════════════
  group('EmployeeDetailMeta.fromJson —', () {
    /// M1 | Branch: happy path, field populated
    /// Expected: parses canKick value correctly
    test('M1: fromJson parses canKick correctly when populated in JSON', () {
      final json = {'canKick': false};

      final meta = EmployeeDetailMeta.fromJson(json);

      expect(meta.canKick, isFalse);
    });

    /// M2 | Branch: null/absent fallback
    /// Expected: canKick defaults to true
    test('M2: fromJson uses true default when canKick is null or absent', () {
      final jsonNull = {'canKick': null};
      final jsonAbsent = <String, dynamic>{};

      final metaNull = EmployeeDetailMeta.fromJson(jsonNull);
      final metaAbsent = EmployeeDetailMeta.fromJson(jsonAbsent);

      expect(metaNull.canKick, isTrue);
      expect(metaAbsent.canKick, isTrue);
    });

    /// M3 | Branch: explicitly true
    /// Expected: canKick is parsed as true
    test('M3: fromJson parses canKick correctly when explicitly true', () {
      final json = {'canKick': true};

      final meta = EmployeeDetailMeta.fromJson(json);

      expect(meta.canKick, isTrue);
    });
  });
}
