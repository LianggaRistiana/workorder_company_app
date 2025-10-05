enum UserRole {
  ownerCompany,
  managerCompany,
  staffCompany,
  staffUnssigned;

  static UserRole fromString(String value) {
    switch (value) {
      case 'owner_company':
        return UserRole.ownerCompany;
      case 'manager_company':
        return UserRole.managerCompany;
      case 'staff_company':
        return UserRole.staffCompany;
      case 'staff_unssigned':
        return UserRole.staffUnssigned;
      default:
        throw Exception('Unknown UserRole: $value');
    }
  }

  String toSnakeCase() {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return name.replaceAllMapped(regex, (match) => '_${match.group(0)!.toLowerCase()}');
  }

    /// Label yang ramah untuk ditampilkan di UI
  String get displayName {
    switch (this) {
      case UserRole.ownerCompany:
        return 'Owner Company';
      case UserRole.managerCompany:
        return 'Manager Company';
      case UserRole.staffCompany:
        return 'Staff Company';
      case UserRole.staffUnssigned:
        return 'Unassigned Staff';
    }
  }

  /// Override toString biar tampil human readable di UI juga
  @override
  String toString() => displayName;
}
