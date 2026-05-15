import 'package:flutter/widgets.dart';

class SystemIntegrationConfigControllers {
  final TextEditingController extenalLoginUrl;
  final TextEditingController externalVerfiyUrl;
  final TextEditingController secretKey;
  final ValueNotifier<bool> isIntegrationActive;

  const SystemIntegrationConfigControllers({
    required this.extenalLoginUrl,
    required this.externalVerfiyUrl,
    required this.secretKey,
    required this.isIntegrationActive,
  });
}
