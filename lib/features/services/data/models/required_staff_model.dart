import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';

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
      'position': (position as PositionModel).toJson(),
      'minimumStaff': minimumStaff,
      'maximumStaff': maximumStaff,
    };
  }
}
