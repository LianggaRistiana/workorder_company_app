import 'package:equatable/equatable.dart';

class ProviderIntegrationDataEntity extends Equatable {
  final String externalLoginUrl;
  final String externalVerifyUrl;
  final String externalCheckStatusMembershipsUrl;
  final String secretKey;
  final bool isIntegrationActive;

  const ProviderIntegrationDataEntity({
    required this.externalLoginUrl,
    required this.externalVerifyUrl,
    required this.externalCheckStatusMembershipsUrl,
    required this.secretKey,
    required this.isIntegrationActive,
  });

  @override
  List<Object?> get props => [
        externalLoginUrl,
        externalVerifyUrl,
        secretKey,
        externalCheckStatusMembershipsUrl,
        isIntegrationActive,
      ];

  @override
  bool? get stringify => true;
}
