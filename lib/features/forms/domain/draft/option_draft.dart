import 'package:workorder_company_app/core/error/error.dart';
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

/// Extension to map OptionDraft to OptionEntity
extension OptionDraftMapper on OptionDraft {
  /// Converts this draft into a fully valid OptionEntity
  OptionEntity toEntity() {
    if (value.isEmpty) {
      throw ValidationException("Value tidak boleh kosong");
    }

    return OptionEntity(
      key: key,
      value: value,
    );
  }
}
