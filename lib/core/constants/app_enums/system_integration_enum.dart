enum IntegrationType {
  externalSystem,
  claimCode;

  factory IntegrationType.fromString(String value) {
    switch (value) {
      case 'external_system':
        return IntegrationType.externalSystem;
      case 'claim_token':
      case 'claim_code':
        return IntegrationType.claimCode;
      default:
        throw Exception('Invalid IntegrationType: $value');
    }
  }

  String displayName() {
    switch (this) {
      case IntegrationType.externalSystem:
        return 'Sistem Eksternal';
      case IntegrationType.claimCode:
        return 'Kode Klaim';
    }
  }

  String toSnakeCase() {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    final name = switch (this) {
      IntegrationType.externalSystem => 'external_system',
      IntegrationType.claimCode => 'claim_token',
    };
    return name.replaceAllMapped(
        regex, (match) => '_${match.group(0)!.toLowerCase()}');
  }
}
