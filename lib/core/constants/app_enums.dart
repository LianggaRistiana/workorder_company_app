enum UserRole {
  ownerCompany,
  managerCompany,
  staffCompany,
  staffUnssigned,
  client;

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
      case 'client':
        return UserRole.client;
      default:
        throw Exception('Unknown UserRole: $value');
    }
  }

  String toSnakeCase() {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return name.replaceAllMapped(
        regex, (match) => '_${match.group(0)!.toLowerCase()}');
  }

  /// Label yang ramah untuk ditampilkan di UI
  String get displayName {
    switch (this) {
      case UserRole.ownerCompany:
        return 'Owner';
      case UserRole.managerCompany:
        return 'Manager';
      case UserRole.staffCompany:
        return 'Staff';
      case UserRole.staffUnssigned:
        return 'Unassigned Staff';
      case UserRole.client:
        return 'Client';
    }
  }

  /// Override toString biar tampil human readable di UI juga
  @override
  String toString() => displayName;
}

enum TypeAccess {
  public,
  memberOnly,
  internal;

  static TypeAccess fromString(String value) {
    switch (value) {
      case 'public':
        return TypeAccess.public;
      case 'member_only':
        return TypeAccess.memberOnly;
      case 'internal':
        return TypeAccess.internal;
      default:
        throw Exception('Unknown TypeAccess: $value');
    }
  }

  String toSnakeCase() {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return name.replaceAllMapped(
        regex, (match) => '_${match.group(0)!.toLowerCase()}');
  }

  String get displayName {
    switch (this) {
      case TypeAccess.public:
        return 'Public';
      case TypeAccess.memberOnly:
        return 'Member Only';
      case TypeAccess.internal:
        return 'Internal';
    }
  }

  @override
  String toString() => displayName;
}
