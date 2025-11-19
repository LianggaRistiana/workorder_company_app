import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.name,
    required super.email,
    required super.role,
    super.position,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: safeParse<String>(json, "name"),
      email: safeParse<String>(json, "email"),
      role: UserRole.fromString(safeParse<String>(json, "role")),
      position: json['position'] != null
          ? PositionModel.fromJson(json['position'])
          : null, // handle null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role.toSnakeCase(),
      'position': position == null
          ? null
          : (position is PositionModel)
              ? (position as PositionModel).toJson()
              : {'_id': position!.id, 'name': position!.name},
    };
  }
}
