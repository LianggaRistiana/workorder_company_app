import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/data/model/field_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_with_history_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/option_model.dart';
import 'package:workorder_company_app/features/forms/data/model/work_reports_filled_form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // OptionModel
  // ─────────────────────────────────────────────────────────────────────────
  group('OptionModel —', () {
    /// M1: fromJson parses key and value correctly.
    test('M1: fromJson parses key and value correctly', () {
      final json = {'key': 'k1', 'value': 'v1'};
      final model = OptionModel.fromJson(json);

      expect(model.key, 'k1');
      expect(model.value, 'v1');
    });

    /// M2: toJson generates correct map.
    test('M2: toJson generates correct map', () {
      const model = OptionModel(key: 'k1', value: 'v1');
      final json = model.toJson();

      expect(json, {'key': 'k1', 'value': 'v1'});
    });

    /// M3: fromEntity maps all fields correctly.
    test('M3: fromEntity maps all fields correctly', () {
      const entity = OptionEntity(key: 'k1', value: 'v1');
      final model = OptionModel.fromEntity(entity);

      expect(model.key, 'k1');
      expect(model.value, 'v1');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // FieldModel
  // ─────────────────────────────────────────────────────────────────────────
  group('FieldModel —', () {
    /// M4: fromJson with options as List of Strings.
    test('M4: fromJson with options as List of Strings parses correctly', () {
      final json = {
        'order': 1,
        'label': 'Field Label',
        'type': 'text',
        'required': true,
        'placeholder': 'Enter text',
        'min': 0,
        'max': 100,
        'options': ['opt1', 'opt2'],
      };

      final model = FieldModel.fromJson(json);

      expect(model.order, 1);
      expect(model.label, 'Field Label');
      expect(model.type, FieldType.text);
      expect(model.required, isTrue);
      expect(model.placeholder, 'Enter text');
      expect(model.min, 0);
      expect(model.max, 100);
      expect(model.options, isNotNull);
      expect(model.options!.length, 2);
      expect(model.options![0].key, 'opt1');
      expect(model.options![0].value, 'opt1');
    });

    /// M5: fromJson with options as List of Maps.
    test('M5: fromJson with options as List of Maps parses correctly', () {
      final json = {
        'order': 2,
        'label': 'Dropdown Field',
        'type': 'single_select',
        'required': false,
        'options': [
          {'key': 'key1', 'value': 'Value 1'},
          {'key': 'key2', 'value': 'Value 2'}
        ],
      };

      final model = FieldModel.fromJson(json);

      expect(model.order, 2);
      expect(model.type, FieldType.singleSelect);
      expect(model.options!.length, 2);
      expect(model.options![0].key, 'key1');
      expect(model.options![0].value, 'Value 1');
    });

    /// M6: fromJson with options as null.
    test('M6: fromJson with null options parses correctly', () {
      final json = {
        'order': 3,
        'label': 'No Options Field',
        'type': 'textarea',
        'required': true,
        'options': null,
      };

      final model = FieldModel.fromJson(json);

      expect(model.options, isNull);
    });

    /// M7: toJson serializes all fields.
    test('M7: toJson serializes all fields correctly', () {
      const model = FieldModel(
        order: 1,
        label: 'Field Label',
        type: FieldType.multiSelect,
        required: true,
        placeholder: 'Select options',
        min: 1,
        max: 5,
        options: [
          OptionModel(key: 'o1', value: 'Opt 1'),
        ],
      );

      final json = model.toJson();

      expect(json, {
        'order': 1,
        'label': 'Field Label',
        'type': 'multi_select',
        'required': true,
        'placeholder': 'Select options',
        'min': 1,
        'max': 5,
        'options': [
          {'key': 'o1', 'value': 'Opt 1'}
        ],
      });
    });

    /// M8: fromEntity maps all fields correctly.
    test('M8: fromEntity maps all fields correctly', () {
      const entity = FieldEntity(
        order: 4,
        label: 'Entity Label',
        type: FieldType.image,
        required: false,
        placeholder: 'Upload image',
        min: 0,
        max: 1,
        options: [
          OptionEntity(key: 'img', value: 'Image'),
        ],
      );

      final model = FieldModel.fromEntity(entity);

      expect(model.order, 4);
      expect(model.type, FieldType.image);
      expect(model.options!.first.key, 'img');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // FormModel
  // ─────────────────────────────────────────────────────────────────────────
  group('FormModel —', () {
    /// M9: fromJson maps all fields including position and fields.
    test('M9: fromJson maps all fields correctly', () {
      final json = {
        '_id': 'form-id-123',
        'title': 'Inspection Form',
        'formType': 'work_order',
        'description': 'Daily inspection sheet',
        'position': {
          '_id': 'pos-id-abc',
          'name': 'Technician',
          'description': 'Field engineer',
          'isActive': true,
        },
        'fields': [
          {
            'order': 1,
            'label': 'Passed?',
            'type': 'single_select',
            'required': true,
            'options': ['Yes', 'No']
          }
        ]
      };

      final model = FormModel.fromJson(json);

      expect(model.id, 'form-id-123');
      expect(model.title, 'Inspection Form');
      expect(model.formType, FormType.workOrder);
      expect(model.description, 'Daily inspection sheet');
      expect(model.position, isNotNull);
      expect(model.position!.id, 'pos-id-abc');
      expect(model.position!.name, 'Technician');
      expect(model.fields, isNotNull);
      expect(model.fields!.length, 1);
      expect(model.fields![0].label, 'Passed?');
    });

    /// M10: fromJsonTemplate generates random ID and parses double-quoted '"position"'.
    test('M10: fromJsonTemplate parses correctly with double-quoted position key', () {
      final json = {
        'title': 'Template Form',
        'formType': 'report',
        'description': 'Daily Report Template',
        '"position"': {
          '_id': 'pos-id-xyz',
          'name': 'Supervisor',
        },
        'fields': null,
      };

      final model = FormModel.fromJsonTemplate(json);

      expect(model.id, isNotEmpty);
      expect(model.id, isNot('form-id-123')); // generates randomly
      expect(model.title, 'Template Form');
      expect(model.formType, FormType.report);
      expect(model.position, isNotNull);
      expect(model.position!.id, 'pos-id-xyz');
      expect(model.position!.name, 'Supervisor');
      expect(model.fields, isEmpty);
    });

    /// M11: toJson serializes all fields.
    test('M11: toJson serializes all fields correctly', () {
      const model = FormModel(
        id: 'form-id-123',
        title: 'Inspection Form',
        formType: FormType.intake,
        description: 'Description text',
        fields: [
          FieldModel(
            order: 1,
            label: 'Field 1',
            type: FieldType.text,
            required: true,
          ),
        ],
      );

      final json = model.toJson();

      expect(json, {
        '_id': 'form-id-123',
        'title': 'Inspection Form',
        'description': 'Description text',
        'formType': 'intake',
        'fields': [
          {
            'order': 1,
            'label': 'Field 1',
            'type': 'text',
            'required': true,
            'placeholder': null,
            'min': null,
            'max': null,
            'options': null,
          }
        ]
      });
    });

    /// M12: fromEntity maps all fields correctly.
    test('M12: fromEntity maps all fields correctly', () {
      const entity = FormEntity(
        id: 'form-entity-id',
        title: 'Title Entity',
        formType: FormType.review,
        description: 'Review description',
        position: PositionModel(id: 'pos-id-789', name: 'Inspector'),
        fields: [],
      );

      final model = FormModel.fromEntity(entity);

      expect(model.id, 'form-entity-id');
      expect(model.title, 'Title Entity');
      expect(model.formType, FormType.review);
      expect(model.position, isNotNull);
      expect(model.position!.id, 'pos-id-789');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // FilledFormModel
  // ─────────────────────────────────────────────────────────────────────────
  group('FilledFormModel —', () {
    final formJson = {
      '_id': 'form-id-123',
      'title': 'Inspection Form',
      'formType': 'work_order',
      'description': 'Daily inspection sheet',
    };

    final submissionJson = {
      '_id': 'sub-id-abc',
      'formId': 'form-id-123',
      'submissionType': 'work_order',
      'fieldsData': [
        {'order': 1, 'value': 'Answer 1'}
      ],
      'createdAt': '2026-06-12T03:37:03Z',
    };

    /// M13: fromJson with non-null submission.
    test('M13: fromJson maps form and submission correctly when both are provided', () {
      final model = FilledFormModel.fromJson(formJson, submissionJson);

      expect(model.form, isNotNull);
      expect(model.form.id, 'form-id-123');
      expect(model.submission, isNotNull);
      expect(model.submission!.id, 'sub-id-abc');
      expect(model.submission!.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
    });

    /// M14: fromJson with null submission.
    test('M14: fromJson maps form correctly and sets submission to null', () {
      final model = FilledFormModel.fromJson(formJson, null);

      expect(model.form, isNotNull);
      expect(model.form.id, 'form-id-123');
      expect(model.submission, isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // FilledFormWithHistoryModel
  // ─────────────────────────────────────────────────────────────────────────
  group('FilledFormWithHistoryModel —', () {
    final formJson = {
      '_id': 'form-id-123',
      'title': 'Inspection Form',
      'formType': 'work_order',
      'description': 'Daily inspection sheet',
    };

    final submissionListJson = [
      {
        '_id': 'sub-oldest',
        'formId': 'form-id-123',
        'submissionType': 'work_order',
        'createdAt': '2026-06-10T12:00:00Z',
      },
      {
        '_id': 'sub-newest',
        'formId': 'form-id-123',
        'submissionType': 'work_order',
        'createdAt': '2026-06-12T12:00:00Z',
      },
      {
        '_id': 'sub-mid',
        'formId': 'form-id-123',
        'submissionType': 'work_order',
        'createdAt': '2026-06-11T12:00:00Z',
      },
    ];

    /// M15: fromJson happy path. Parses submissions and sorts by createdAt descending.
    test('M15: fromJson parses correctly and sorts submissions by createdAt descending', () {
      final model = FilledFormWithHistoryModel.fromJson(formJson, submissionListJson);

      expect(model.form.id, 'form-id-123');
      expect(model.submissionHistory, isNotNull);
      expect(model.submissionHistory!.length, 3);
      expect(model.submissionHistory![0].id, 'sub-newest'); // 2026-06-12
      expect(model.submissionHistory![1].id, 'sub-mid');    // 2026-06-11
      expect(model.submissionHistory![2].id, 'sub-oldest'); // 2026-06-10
    });

    /// M16: fromJson throws ParsingException when formJson is not Map.
    test('M16: fromJson throws ParsingException when formJson is not Map', () {
      expect(
        () => FilledFormWithHistoryModel.fromJson('not-a-map', submissionListJson),
        throwsA(isA<ParsingException>().having(
          (e) => e.message,
          'message',
          contains("Field 'form' expected Map<String, dynamic> but got String"),
        )),
      );
    });

    /// M17: fromJson throws ParsingException when submissionsJson is not List.
    test('M17: fromJson throws ParsingException when submissionsJson is not List', () {
      expect(
        () => FilledFormWithHistoryModel.fromJson(formJson, 'not-a-list'),
        throwsA(isA<ParsingException>().having(
          (e) => e.message,
          'message',
          contains("Field 'submissions' expected List but got String"),
        )),
      );
    });

    /// M18: fromJson throws ParsingException when a submission in submissionsJson is not Map.
    test('M18: fromJson throws ParsingException when a submission in submissionsJson is not Map', () {
      final invalidList = [
        'not-a-map'
      ];
      expect(
        () => FilledFormWithHistoryModel.fromJson(formJson, invalidList),
        throwsA(isA<ParsingException>().having(
          (e) => e.message,
          'message',
          contains("Each submission must be Map<String, dynamic> but got String"),
        )),
      );
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // WorkReportsFilledFormModel
  // ─────────────────────────────────────────────────────────────────────────
  group('WorkReportsFilledFormModel —', () {
    final form1 = {
      '_id': 'form-1',
      'title': 'Form One',
      'formType': 'report',
      'description': 'First Form',
    };

    final form2 = {
      '_id': 'form-2',
      'title': 'Form Two',
      'formType': 'report',
      'description': 'Second Form',
    };

    final sub1 = {
      '_id': 'sub-f1-old',
      'formId': 'form-1',
      'submissionType': 'report',
      'createdAt': '2026-06-11T12:00:00Z',
    };

    final sub2 = {
      '_id': 'sub-f1-new',
      'formId': 'form-1',
      'submissionType': 'report',
      'createdAt': '2026-06-12T12:00:00Z',
    };

    /// M19: fromJson groups forms and submissions, sorts submissions, maps to FilledFormModel.
    test('M19: fromJson maps forms to submissions by formId correctly, selecting newest submission', () {
      final json = {
        'workReportForms': [form1, form2],
        'submissions': [sub1, sub2],
      };

      final model = WorkReportsFilledFormModel.fromJson(json);

      expect(model.filledForms.length, 2);

      // Form 1 should have submission 'sub-f1-new' because it is newer than 'sub-f1-old'
      final filled1 = model.filledForms.firstWhere((e) => e.form.id == 'form-1');
      expect(filled1.submission, isNotNull);
      expect(filled1.submission!.id, 'sub-f1-new');

      // Form 2 should have null submission
      final filled2 = model.filledForms.firstWhere((e) => e.form.id == 'form-2');
      expect(filled2.submission, isNull);
    });

    /// M20: fromJson with null submissions list parses correctly.
    test('M20: fromJson parses correctly when submissions list is null', () {
      final json = {
        'workReportForms': [form1],
        'submissions': null,
      };

      final model = WorkReportsFilledFormModel.fromJson(json);

      expect(model.filledForms.length, 1);
      expect(model.filledForms[0].form.id, 'form-1');
      expect(model.filledForms[0].submission, isNull);
    });
  });
}
