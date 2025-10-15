import 'package:workorder_company_app/features/forms/data/model/field_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

class FormModel extends FormEntity {
  const FormModel({
    required super.id,
    required super.title,
    required super.description,
    // required super.accessType,
    // required super.accessibleBy,
    // super.allowedPositions = const [],
    super.fields = const [],
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json["_id"].toString(),
      title: json["title"].toString(),
      description: json["description"]?.toString() ?? "",
      // accessType: json["accessType"]?.toString() ?? "",
      // accessibleBy: (json["accessibleBy"] as List<dynamic>?)
      //         ?.map((e) => e.toString())
      //         .toList() ??
      //     [],
      // allowedPositions: (json["allowedPositions"] as List<dynamic>?)
      //         ?.map((e) => PositionModel.fromJson(e))
      //         .toList() ??
      //     [],
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
      // "accessType": accessType,
      // "accessibleBy": accessibleBy,
      // "allowedPositions":
      //     // allowedPositions?.map((e) => (e as PositionModel).toJson()).toList(),
      //     allowedPositions?.map((e) => e.id).toList(),
      "fields": fields?.map((e) => (e as FieldModel).toJson()).toList(),
    };
  }

  factory FormModel.fromEntity(FormEntity entity) {
    return FormModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      // accessType: entity.accessType,
      // accessibleBy: entity.accessibleBy,
      // allowedPositions: entity.allowedPositions
      //     ?.map((e) => PositionModel.fromEntity(e))
      //     .toList(),
      fields: entity.fields?.map((e) => FieldModel.fromEntity(e)).toList(),
    );
  }
}
