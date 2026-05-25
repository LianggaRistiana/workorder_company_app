enum IntegrationType {
  externalSystem,
  claimCode;

  factory IntegrationType.fromString(String value) {
    switch (value) {
      case 'external_system':
        return IntegrationType.externalSystem;
      case 'claim_code':
        return IntegrationType.claimCode;
      default:
        throw Exception('Invalid IntegrationType: $value');
    }
  }

  String displayName() {
    switch (this) {
      case IntegrationType.externalSystem:
        return 'sistem eksternal';
      case IntegrationType.claimCode:
        return 'kode klaim';
    }
  }
  
  String toSnakeCase() {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return name.replaceAllMapped(
        regex, (match) => '_${match.group(0)!.toLowerCase()}');
  }
}
