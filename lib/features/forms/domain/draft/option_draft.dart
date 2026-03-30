import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';

class OptionDraft {
  final String key;
  String _value;

  OptionDraft({
    String? key,
    String value = '',
  })  : key = key ?? _generateKey(),
        _value = value.trim();

  /// Getter
  String get value => _value;

  /// Setter
  set value(String newValue) {
    _value = newValue.trim();
  }

  /// Update value tanpa setter (optional helper)
  void updateValue(String newValue) {
    _value = newValue.trim();
  }

  /// From Entity -> Draft
  factory OptionDraft.fromEntity(OptionEntity entity) {
    return OptionDraft(
      key: entity.key,
      value: entity.value,
    );
  }

  static String _generateKey() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}