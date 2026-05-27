import 'package:workorder_company_app/core/constants/app_enums/system_integration_enum.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';

class ExternalUserModel extends ExternalUserEntity {
  const ExternalUserModel({
    required super.id,
    required super.externalEmail,
    required super.externalName,
    required super.company,
    required super.integrationType,
    required super.pairedAt,
  });

  factory ExternalUserModel.fromJson(Map<String, dynamic> json) {
    return ExternalUserModel(
      id: json.field("_id").reqString(),
      integrationType:
          json.field("integration_type").reqEnum(IntegrationType.fromString),
      externalEmail: json.field("external_customer_email").reqString(),
      externalName: json.field("external_customer_name").reqString(),
      company: json.field("company").reqModel(CompanyModel.fromJson),
      pairedAt: json.field("paired_at").reqDate(),
    );
  }
}
