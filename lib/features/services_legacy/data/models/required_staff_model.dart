import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services_legacy/domain/entities/required_staff_entity.dart';

class RequiredStaffModel extends RequiredStaffEntity {
  const RequiredStaffModel({
    required super.position,
    required super.minimumStaff,
    required super.maximumStaff,
  });

  /// Convert from JSON → Model
  factory RequiredStaffModel.fromJson(Map<String, dynamic> json) {
    return RequiredStaffModel(
      position: PositionModel.fromJson(json['position']),
      minimumStaff: json['minimumStaff'] ?? 0,
      maximumStaff: json['maximumStaff'] ?? 0,
    );
  }

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'positionId': (position as PositionModel).id,
      'minimumStaff': minimumStaff,
      'maximumStaff': maximumStaff,
    };
  }

  factory RequiredStaffModel.fromEntity(RequiredStaffEntity entity) {
    return RequiredStaffModel(
      position: entity.position is PositionModel
          ? entity.position as PositionModel
          : PositionModel.fromEntity(entity.position),
      minimumStaff: entity.minimumStaff,
      maximumStaff: entity.maximumStaff,
    );
  }
}
