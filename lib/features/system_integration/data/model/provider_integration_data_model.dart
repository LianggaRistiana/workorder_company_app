import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/provider_integration_data_entity.dart';

class ProviderIntegrationDataModel extends ProviderIntegrationDataEntity {
  const ProviderIntegrationDataModel({
    required super.externalLoginUrl,
    required super.externalVerifyUrl,
    required super.secretKey,
    required super.externalCheckStatusMembershipsUrl,
    required super.isIntegrationActive,
  });

  factory ProviderIntegrationDataModel.fromJson(Map<String, dynamic> json) {
    return ProviderIntegrationDataModel(
      externalLoginUrl: json.field("external_login_url").reqString(),
      externalVerifyUrl: json.field("external_verify_url").reqString(),
      secretKey: json.field("secret_key").reqString(),
      externalCheckStatusMembershipsUrl:
          json.field("external_check_status_memberships_url").reqString(),
      isIntegrationActive: json.field("is_integration_active").reqBool(),
    );
  }

  factory ProviderIntegrationDataModel.fromEntity(
    ProviderIntegrationDataEntity providerIntegrationData,
  ) {
    return ProviderIntegrationDataModel(
      externalLoginUrl: providerIntegrationData.externalLoginUrl,
      externalVerifyUrl: providerIntegrationData.externalVerifyUrl,
      secretKey: providerIntegrationData.secretKey,
      externalCheckStatusMembershipsUrl:
          providerIntegrationData.externalCheckStatusMembershipsUrl,
      isIntegrationActive: providerIntegrationData.isIntegrationActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "external_login_url": externalLoginUrl,
      "external_verify_url": externalVerifyUrl,
      "external_check_status_memberships_url": externalCheckStatusMembershipsUrl,
      "secret_key": secretKey,
      "is_integration_active": isIntegrationActive,
    };
  }
}
