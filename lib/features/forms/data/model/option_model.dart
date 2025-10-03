import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';

class OptionModel extends OptionEntity {
  const OptionModel({
    required super.key,
    required super.value,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      key: json["key"] ?? json.toString(),
      value: json["value"] ?? json.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "value": value,
    };
  }
}