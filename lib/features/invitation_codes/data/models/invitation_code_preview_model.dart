import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_preview_entity.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

class InvitationCodePreviewModel extends InvitationCodePreviewEntity {
  InvitationCodePreviewModel({
    required super.code,
    super.company,
    required super.role,
    super.position,
    super.expiresAt,
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

  factory InvitationCodePreviewModel.fromJson(Map<String, dynamic> json) {
    return InvitationCodePreviewModel(
      code: json.field('code').reqString(),
      role: _parseRole(json.field('role').reqString()),
      expiresAt: json.field('expiresAt').optDate(),
      company: json['company'] is Map<String, dynamic>
          ? json.field('company').optModel(CompanyModel.fromJson)
          : null,
      position: json.field('position').optModel(PositionModel.fromJson),
    );
  }
}
