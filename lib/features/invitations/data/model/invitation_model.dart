import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_summary_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

class InvitationModel extends InvitationEntity {
  InvitationModel({
    required super.id,
    required super.role,
    required super.status,
    super.company,
    super.toUser,
    super.createdAt,
    super.updatedAt,
    super.expiresAt,
    super.position,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
        id: json.field('_id').reqString(),
        role: json.field("role").reqEnum(UserRole.fromString),
        toUser: json.field("user").optModel(UserSummaryModel.fromJson),
        status: json.field("status").reqEnum(InvitationStatus.fromString),
        createdAt: json.field("createdAt").optDate(),
        updatedAt: json.field("updatedAt").optDate(),
        expiresAt: json.field("expiresAt").optDate(),
        company: json.field("company").optModel(CompanyModel.fromJson),
        position: json.field("position").optModel(PositionModel.fromJson));
  }
}
