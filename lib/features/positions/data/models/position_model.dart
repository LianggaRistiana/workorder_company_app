import 'package:workorder_company_app/core/services/generator/random_string.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class PositionModel extends PositionEntity {
  const PositionModel({
    required super.id,
    required super.name,
    super.description,
    super.isActive = true,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      id: safeParse<String>(json, "_id"),
      name: safeParse<String>(json, "name"),
      description:
          safeParse<String?>(json, "description", requiredField: false),
      isActive:
          safeParse<bool?>(json, "isActive", requiredField: false) ?? true,
    );
  }

  factory PositionModel.fromJsonTemplate(Map<String, dynamic> json) {
    return PositionModel(
      id: RandomString.generate(),
      name: safeParse<String>(json, "name"),
      description:
          safeParse<String?>(json, "description", requiredField: false),
      isActive:
          safeParse<bool?>(json, "isActive", requiredField: false) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
    };
  }

  factory PositionModel.fromEntity(PositionEntity entity) {
    return PositionModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      isActive: entity.isActive,
    );
  }
}
