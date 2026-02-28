import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/invitations/domain/entitties/invitations_entity.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

class InvitationsModel extends InvitationsEntity {
  InvitationsModel({required super.email, required super.role, super.position});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "role": role.toSnakeCase(),
      "position": position?.id,
    };
  }

  factory InvitationsModel.fromJson(Map<String, dynamic> json) {
    return InvitationsModel(
      email: safeParse<String>(json, "email"),
      role: UserRole.fromString(safeParse<String>(json, "role")),
      position: PositionModel.fromJson(
          safeParse<Map<String, dynamic>>(json, "position")),
    );
  }

  factory InvitationsModel.fromEntity(InvitationsEntity entity) {
    return InvitationsModel(
      email: entity.email,
      role: entity.role,
      position: entity.position,
    );
  }
}
