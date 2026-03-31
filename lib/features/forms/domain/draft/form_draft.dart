import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/draft/field_draft.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/shared/utils/reorder_helper_util.dart';

class FormDraft {
  String? id;

  String _title;
  String _description;

  FormType formType;
  List<FieldDraft> fields;

  FormDraft({
    this.id,
    String title = '',
    String description = '',
    this.formType = FormType.workOrder,
    List<FieldDraft>? fields,
  })  : _title = title.trim(),
        _description = description.trim(),
        fields = fields ?? [];

  /// =========================
  /// Getter & Setter
  /// =========================

  String get title => _title;
  set title(String value) {
    _title = value.trim();
  }

  String get description => _description;
  set description(String value) {
    _description = value.trim();
  }

  void updateTitle(String value) {
    _title = value.trim();
  }

  void updateDescription(String value) {
    _description = value.trim();
  }

  void updateFormType(FormType value) {
    formType = value;
  }

  /// =========================
  /// Field Management
  /// =========================

  void addField(FieldType type) {
    fields.add(FieldDraft(order: fields.length + 1, type: type));
  }

  void removeField(int index) {
    fields.removeAt(index);
    for (int i = 0; i < fields.length; i++) {
      fields[i].order = i + 1;
    }
  }

  void clearFields() {
    fields.clear();
  }

  void moveField(int oldIndex, int newIndex) {
    fields.reorderWithCallback(
      oldIndex,
      newIndex,
      (item, index) {
        item.order = index + 1;
      },
    );
  }

  /// =========================
  /// CopyWith (untuk state management)
  /// =========================

  FormDraft copyWith({
    String? id,
    String? title,
    String? description,
    FormType? formType,
    List<FieldDraft>? fields,
  }) {
    return FormDraft(
      id: id ?? this.id,
      title: title ?? _title,
      description: description ?? _description,
      formType: formType ?? this.formType,
      fields: fields ?? List<FieldDraft>.from(this.fields),
    );
  }

  /// =========================
  /// Factory
  /// =========================

  factory FormDraft.empty() {
    return FormDraft();
  }

  factory FormDraft.fromEntity(FormEntity entity) {
    return FormDraft(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      formType: entity.formType,
      fields:
          entity.fields?.map((f) => FieldDraft.fromEntity(f)).toList() ?? [],
    );
  }
}

extension FormDraftMapper on FormDraft {
  /// Converts the draft into an entity.
  ///
  /// Throws [ValidationException] if any field is invalid or if there are no fields.
  FormEntity toEntity() {
    // 1️⃣ Validate title
    if (title.isEmpty) {
      throw ValidationException("Form title cannot be empty.");
    }

    // 2️⃣ Validate fields (at least 1 field)
    if (fields.isEmpty) {
      throw ValidationException("Form must contain at least 1 field.");
    }

    // 3️⃣ Map fields
    final mappedFields = fields.map((f) => f.toEntity()).toList();

    // 4️⃣ Return mapped entity
    return FormEntity(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      formType: formType,
      fields: mappedFields,
    );
  }
}
