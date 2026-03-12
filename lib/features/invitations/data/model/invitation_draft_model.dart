import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/invitations/domain/entitties/invitation_draft_entity.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

class InvitationDraftModel extends InvitationDraftEntity {
  InvitationDraftModel({required super.email, required super.role, super.position});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "role": role.toSnakeCase(),
      "positionId": position?.id,
    };
  }

  factory InvitationDraftModel.fromJson(Map<String, dynamic> json) {
    return InvitationDraftModel(
      email: safeParse<String>(json, "email"),
      role: UserRole.fromString(safeParse<String>(json, "role")),
      position: PositionModel.fromJson(
          safeParse<Map<String, dynamic>>(json, "position")),
    );
  }

  factory InvitationDraftModel.fromEntity(InvitationDraftEntity entity) {
    return InvitationDraftModel(
      email: entity.email,
      role: entity.role,
      position: entity.position,
    );
  }
}
