import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_summary_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/invitations/domain/entitties/invitation_entity.dart';

class InvitationModel extends InvitationEntity {
  InvitationModel(
      {required super.id,
      required super.role,
      required super.status,
      required super.company,
      required super.toUser,
      super.createdAt,
      super.updatedAt,
      super.expiresAt,
      super.position});

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: safeParse<String>(json, "_id"),
      role: UserRole.fromString(safeParse<String>(json, "role")),
      toUser: UserSummaryModel.fromJson(json['user']),
      status: InvitationStatus.fromString(safeParse<String>(json, "status")),
      createdAt: safeParse<DateTime>(
        json,
        "createdAt",
        requiredField: false,
        parser: (value) => DateTime.parse(value as String),
      ),
      updatedAt: safeParse<DateTime>(
        json,
        "updatedAt",
        requiredField: false,
        parser: (value) => DateTime.parse(value as String),
      ),
      expiresAt: safeParse<DateTime>(
        json,
        "expiresAt",
        requiredField: false,
        parser: (value) => DateTime.parse(value as String),
      ),
      company: CompanyModel.fromJson(json['company']),
    );
  }
}
