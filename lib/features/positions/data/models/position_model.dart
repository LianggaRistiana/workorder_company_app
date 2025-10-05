import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class PositionModel extends PositionEntity {
  const PositionModel({
    required super.id,
    required super.name,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }

  factory PositionModel.fromEntity(PositionEntity entity) {
    return PositionModel(
      id: entity.id,
      name: entity.name,
    );
  }
}
