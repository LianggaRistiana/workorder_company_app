import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class ProviderIntegrationDataEntity extends Equatable {
  final String externalLoginUrl;
  final String externalVerifyUrl;
  final String externalCheckStatusMembershipsUrl;
  final String secretKey;
  final bool isIntegrationActive;
  final IntegrationType integrationType;

  const ProviderIntegrationDataEntity({
    required this.externalLoginUrl,
    required this.externalVerifyUrl,
    required this.externalCheckStatusMembershipsUrl,
    required this.secretKey,
    required this.isIntegrationActive,
    this.integrationType = IntegrationType.externalSystem,
  });

  @override
  List<Object?> get props => [
        externalLoginUrl,
        externalVerifyUrl,
        secretKey,
        externalCheckStatusMembershipsUrl,
        integrationType,
        isIntegrationActive,
      ];

  @override
  bool? get stringify => true;
}
