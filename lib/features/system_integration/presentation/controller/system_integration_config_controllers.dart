import 'package:flutter/widgets.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/provider_integration_data_entity.dart';

class SystemIntegrationConfigControllers {
  final TextEditingController externalLoginUrl;
  final TextEditingController externalVerifyUrl;
  final TextEditingController externalCheckStatusMembershipsUrl;
  final TextEditingController secretKey;
  final ValueNotifier<bool> isIntegrationActive;

  SystemIntegrationConfigControllers({
    required this.externalLoginUrl,
    required this.externalVerifyUrl,
    required this.externalCheckStatusMembershipsUrl,
    required this.secretKey,
    required this.isIntegrationActive,
  });

  factory SystemIntegrationConfigControllers.create() {
    return SystemIntegrationConfigControllers(
      externalLoginUrl: TextEditingController(),
      externalCheckStatusMembershipsUrl: TextEditingController(),
      externalVerifyUrl: TextEditingController(),
      secretKey: TextEditingController(),
      isIntegrationActive: ValueNotifier(false),
    );
  }

  void initValues(ProviderIntegrationDataEntity data) {
    externalLoginUrl.text = data.externalLoginUrl;
    externalVerifyUrl.text = data.externalVerifyUrl;
    externalCheckStatusMembershipsUrl.text =
        data.externalCheckStatusMembershipsUrl;
    secretKey.text = data.secretKey;
    isIntegrationActive.value = data.isIntegrationActive;
  }

  bool isDirty(ProviderIntegrationDataEntity data) {
    return externalLoginUrl.text != data.externalLoginUrl ||
        externalVerifyUrl.text != data.externalVerifyUrl ||
        secretKey.text != data.secretKey ||
        externalCheckStatusMembershipsUrl.text !=
            data.externalCheckStatusMembershipsUrl ||
        isIntegrationActive.value != data.isIntegrationActive;
  }

  ProviderIntegrationDataEntity get buildData => ProviderIntegrationDataEntity(
        externalLoginUrl: externalLoginUrl.text,
        externalCheckStatusMembershipsUrl:
            externalCheckStatusMembershipsUrl.text,
        externalVerifyUrl: externalVerifyUrl.text,
        secretKey: secretKey.text,
        isIntegrationActive: isIntegrationActive.value,
      );

  void dispose() {
    externalLoginUrl.dispose();
    externalVerifyUrl.dispose();
    externalCheckStatusMembershipsUrl.dispose();
    secretKey.dispose();
    isIntegrationActive.dispose();
  }
}
