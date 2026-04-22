import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/field_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

class FormModel extends FormEntity {
  const FormModel({
    required super.id,
    required super.title,
    required super.formType,
    required super.description,
    super.fields = const [],
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: safeParse<String>(json, "_id"),
      title: safeParse<String>(json, "title"),
      formType: FormType.fromString(json["formType"].toString()),
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
      formType: entity.formType,
      fields: entity.fields?.map((e) => FieldModel.fromEntity(e)).toList(),
    );
  }
}
