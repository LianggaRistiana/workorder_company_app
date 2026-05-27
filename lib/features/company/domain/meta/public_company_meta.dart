import 'package:workorder_company_app/core/constants/app_enums/system_integration_enum.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';

class PublicCompanyMeta extends ResultMeta {
  final bool isSubcribbed;
  final bool isIntegrationActive;
  final IntegrationType? integrationType;

  const PublicCompanyMeta({
    required this.isSubcribbed,
    required this.isIntegrationActive,
    this.integrationType,
  });

  factory PublicCompanyMeta.fromJson(Map<String, dynamic> json) {
    return PublicCompanyMeta(
      isSubcribbed: json['isSubscribed'] ?? false,
      isIntegrationActive: json['isIntegrationActive'] ?? false,
      integrationType:
          json.field('integrationType').optEnum(IntegrationType.fromString),
    );
  }
}
