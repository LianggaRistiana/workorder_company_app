import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';

class OptionModel extends OptionEntity {
  const OptionModel({
    required super.key,
    required super.value,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      key: safeParse<String>(json, "key"),
      value: safeParse<String>(json, "value"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "value": value,
    };
  }

  factory OptionModel.fromEntity(OptionEntity entity) {
    return OptionModel(
      key: entity.key,
      value: entity.value,
    );
  }
}
