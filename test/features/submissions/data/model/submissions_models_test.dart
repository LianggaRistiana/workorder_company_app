import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/submissions/data/model/field_data_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/upload_payload.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/field_data_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/submission_entity.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════
  // FieldDataModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('FieldDataModel —', () {
    /// M1: fromJson parses order and value correctly
    test('M1: fromJson parses string order and dynamic value', () {
      final json = {'order': 1, 'value': 'some value'};
      final model = FieldDataModel.fromJson(json);

      expect(model.order, '1');
      expect(model.value, 'some value');
    });

    /// M2: toJson serializes correctly, converting order to int and datetime to string
    test('M2: toJson serializes order as int and dateTime value as ISO string', () {
      final modelNormal = FieldDataModel(order: '2', value: 'normal');
      final jsonNormal = modelNormal.toJson();
      expect(jsonNormal['order'], 2);
      expect(jsonNormal['value'], 'normal');

      final dateValue = DateTime(2026, 6, 12, 12, 0, 0);
      final modelDate = FieldDataModel(order: '3', value: dateValue);
      final jsonDate = modelDate.toJson();
      expect(jsonDate['order'], 3);
      expect(jsonDate['value'], dateValue.toIso8601String());
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // SubmissionsModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('SubmissionsModel —', () {
    Map<String, dynamic> makeSubmissionJson() => {
          '_id': 'sub-123',
          'formId': 'form-456',
          'submissionType': 'report',
          'fieldsData': [
            {'order': 0, 'value': 'field-value'},
          ],
          'createdAt': '2026-06-12T03:37:03Z',
        };

    /// M3: fromJson parses valid fields correctly
    test('M3: fromJson parses all fields correctly', () {
      final json = makeSubmissionJson();
      final model = SubmissionsModel.fromJson(json);

      expect(model.id, 'sub-123');
      expect(model.formId, 'form-456');
      expect(model.submissionType, FormType.report);
      expect(model.fieldsData!.length, 1);
      expect(model.fieldsData![0].order, '0');
      expect(model.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
    });

    /// M4: toJson maps correctly
    test('M4: toJson returns valid JSON map with snake_case submissionType', () {
      final model = SubmissionsModel(
        id: 'sub-123',
        formId: 'form-456',
        submissionType: FormType.report,
        fieldsData: [
          FieldDataModel(order: '1', value: 'val'),
        ],
        createdAt: DateTime(2026, 6, 12),
      );

      final json = model.toJson();

      expect(json['id'], 'sub-123');
      expect(json['formId'], 'form-456');
      expect(json['submissionType'], 'report');
      expect(json['fieldsData'].length, 1);
      expect(json['fieldsData'][0]['order'], 1);
    });

    /// M5: fromEntity maps correctly
    test('M5: fromEntity maps all fields correctly', () {
      final entity = SubmissionEntity(
        id: 'sub-123',
        formId: 'form-456',
        submissionType: FormType.report,
        fieldsData: [
          FieldDataEntity(order: '1', value: 'val'),
        ],
        createdAt: DateTime(2026, 6, 12),
      );

      final model = SubmissionsModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.formId, entity.formId);
      expect(model.submissionType, entity.submissionType);
      expect(model.fieldsData!.length, 1);
      expect(model.fieldsData![0].order, '1');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // UploadPayload Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('UploadPayload —', () {
    /// M6: fromMap parses url correctly
    test('M6: fromMap parses url correctly from map', () {
      final map = {'url': 'https://s3.example.com/file.png'};
      final model = UploadPayload.fromMap(map);

      expect(model.url, 'https://s3.example.com/file.png');
    });
  });
}
