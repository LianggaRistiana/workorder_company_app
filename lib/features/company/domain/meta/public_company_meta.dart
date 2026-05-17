import 'package:workorder_company_app/core/result/result.dart';

class PublicCompanyMeta extends ResultMeta {
  final bool isSubcribbed;
  final bool isIntegrationActive;

  const PublicCompanyMeta({
    required this.isSubcribbed,
    required this.isIntegrationActive,
  });

  factory PublicCompanyMeta.fromJson(Map<String, dynamic> json) {
    return PublicCompanyMeta(
      isSubcribbed: json['isSubcribbed'] ?? false,
      isIntegrationActive: json['isIntegrationActive'] ?? false,
    );
  }
}
