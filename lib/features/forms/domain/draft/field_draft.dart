import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/draft/option_draft.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';

class FieldDraft {
  final String uiKey = DateTime.now().microsecondsSinceEpoch.toString();
  int? order;
  String _label;
  FieldType type;
  bool required;
  String? placeholder;
  int? min;
  int? max;
  List<OptionDraft> options;

  FieldDraft({
    this.order,
    String label = '',
    this.type = FieldType.text,
    this.required = false,
    this.placeholder,
    this.min,
    this.max,
    List<OptionDraft>? options,
  })  : _label = label.trim(),
        options = options ?? [];

  /// =========================
  /// Getter & Setter
  /// =========================

  String get label => _label;

  set label(String newLabel) {
    _label = newLabel.trim();
  }

  void updateLabel(String newLabel) {
    _label = newLabel.trim();
  }

  void updateRequired(bool value) {
    required = value;
  }

  void updateFieldPlaceholder(String placeholder) {
    this.placeholder = placeholder;
  }

  void updateMin(
    int min,
  ) {
    this.min = min;
  }

  void updateMax(
    int max,
  ) {
    this.max = max;
  }

  /// =========================
  /// Option Management
  /// =========================

  void addOption(OptionDraft option) {
    options.add(option);
  }

  void removeOptionByKey(String key) {
    options.removeWhere((o) => o.key == key);
  }

  void clearOptions() {
    options.clear();
  }

  void updateOptionValue(String key, String value) {
    final index = options.indexWhere((o) => o.key == key);
    if (index != -1) {
      options[index].value = value;
    }
  }

  /// =========================
  /// From Entity -> Draft
  /// =========================

  factory FieldDraft.fromEntity(FieldEntity entity) {
    return FieldDraft(
      order: entity.order,
      label: entity.label,
      type: entity.type,
      required: entity.required,
      placeholder: entity.placeholder,
      min: entity.min,
      max: entity.max,
      options:
          entity.options?.map((o) => OptionDraft.fromEntity(o)).toList() ?? [],
    );
  }
}

/// Mapper extension for FieldDraft -> FieldEntity
extension FieldDraftMapper on FieldDraft {
  FieldEntity toEntity() {
    // 1️⃣ Validate label
    if (label.isEmpty) {
      throw ValidationException("Field label cannot be empty.");
    }

    // 2️⃣ Validate number config
    if (type == FieldType.number) {
      if (min != null && max != null && min! > max!) {
        throw ValidationException(
            "Field min value cannot be greater than max value.");
      }
    }

    // 3️⃣ Validate options for select types
    if (type == FieldType.multiSelect || type == FieldType.singleSelect) {
      if (options.length < 2) {
        throw ValidationException("Select field must have at least 2 options.");
      }
      for (final option in options) {
        if (option.value.isEmpty) {
          throw ValidationException("Select field option cannot be empty.");
        }
      }
    }

    if (order == null) {
      throw ValidationException("Field order cannot be null.");
    }

    // 4️⃣ Return mapped entity
    return FieldEntity(
      order: order!,
      label: label,
      type: type,
      required: required,
      placeholder: placeholder,
      min: min,
      max: max,
      options:
          options.isNotEmpty ? options.map((o) => o.toEntity()).toList() : null,
    );
  }
}
