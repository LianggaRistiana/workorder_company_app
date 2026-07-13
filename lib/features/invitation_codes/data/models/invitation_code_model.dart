import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_summary_model.dart';
// import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

class InvitationCodeModel extends InvitationCodeEntity {
  InvitationCodeModel({
    required super.id,
    required super.code,
    required super.role,
    super.company,
    super.position,
    super.createdBy,
    required super.isActive,
    super.maxUses,
    required super.usedCount,
    super.remainingUses,
    required super.isClaimable,
    super.expiresAt,
    super.createdAt,
    super.updatedAt,
  });

  static UserRole _parseRole(String val) {
    switch (val) {
      case 'company_staff':
      case 'staff_company':
        return UserRole.staffCompany;
      case 'company_manager':
      case 'manager_company':
        return UserRole.managerCompany;
      default:
        return UserRole.fromString(val);
    }
  }

  factory InvitationCodeModel.fromJson(Map<String, dynamic> json) {
    return InvitationCodeModel(
      id: json.field('_id').reqString(),
      code: json.field('code').reqString(),
      role: _parseRole(json.field('role').reqString()),
      isActive: json.field('isActive').reqBool(),
      usedCount: json.field('usedCount').optInt() ?? 0,
      isClaimable: json.field('isClaimable').optBool() ?? false,
      maxUses: json.field('maxUses').optInt(),
      remainingUses: json.field('remainingUses').optInt(),
      expiresAt: json.field('expiresAt').optDate(),
      createdAt: json.field('createdAt').optDate(),
      updatedAt: json.field('updatedAt').optDate(),
      // company: json['company'] is Map<String, dynamic>
      //     ? json.field('company').optModel(CompanyModel.fromJson)
      //     : null,
      position: json.field('position').optModel(PositionModel.fromJson),
      createdBy: json.field('createdBy').optModel(UserSummaryModel.fromJson),
    );
  }
}
