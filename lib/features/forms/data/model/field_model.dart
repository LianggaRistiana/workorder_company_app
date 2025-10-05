import 'package:workorder_company_app/features/forms/data/model/option_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';

class FieldModel extends FieldEntity {
  const FieldModel({
    super.order,
    required super.label,
    required super.type,
    required super.required,
    super.placeholder,
    super.min,
    super.max,
    super.options,
  });

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      order: json["order"],
      label: json["label"],
      type: json["type"],
      required: json["required"],
      placeholder: json["placeholder"],
      min: json["min"],
      max: json["max"],
      options: json["options"] != null
          ? (json["options"] as List).map((e) {
              if (e is String) {
                return OptionModel(key: e, value: e);
              } else {
                return OptionModel.fromJson(e);
              }
            }).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "order": order,
      "label": label,
      "type": type,
      "required": required,
      "placeholder": placeholder,
      "min": min,
      "max": max,
      "options": options?.map((e) => (e as OptionModel).toJson()).toList(),
    };
  }

  factory FieldModel.fromEntity(FieldEntity entity) {
    return FieldModel(
      order: entity.order,
      label: entity.label,
      type: entity.type,
      required: entity.required,
      placeholder: entity.placeholder,
      min: entity.min,
      max: entity.max,
      options: entity.options?.map((e) => OptionModel.fromEntity(e)).toList(),
    );
  }
}
