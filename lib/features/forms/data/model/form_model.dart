import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/services/generator/random_string.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/field_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

// TODO : Test
class FormModel extends FormEntity {
  const FormModel({
    required super.id,
    required super.title,
    required super.formType,
    required super.description,
    super.position,
    super.fields = const [],
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json.field('_id').reqString(),
      title: json.field('title').reqString(),
      formType: json.field('formType').reqEnum(FormType.fromString),
      position: json.field('"position"').optModel(PositionModel.fromJson),
      description: json["description"]?.toString() ?? "",
      fields: (json["fields"] as List<dynamic>?)
              ?.map((e) => FieldModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  factory FormModel.fromJsonTemplate(Map<String, dynamic> json) {
    return FormModel(
      id: RandomString.generate(),
      title: json.field('title').reqString(),
      formType: json.field('formType').reqEnum(FormType.fromString),
      position: json.field('"position"').optModel(PositionModel.fromJson),
      description: json["description"]?.toString() ?? "",
      fields: (json["fields"] as List<dynamic>?)
              ?.map((e) => FieldModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "formType": formType.toSnakeCase(),
      "fields": fields?.map((e) => (e as FieldModel).toJson()).toList(),
    };
  }

  factory FormModel.fromEntity(FormEntity entity) {
    return FormModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      position: entity.position,
      formType: entity.formType,
      fields: entity.fields?.map((e) => FieldModel.fromEntity(e)).toList(),
    );
  }
}
