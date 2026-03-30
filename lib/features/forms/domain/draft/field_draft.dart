import 'package:workorder_company_app/core/constants/app_enums.dart';
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
    placeholder = placeholder.trim();
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
