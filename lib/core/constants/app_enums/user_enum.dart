import 'package:workorder_company_app/core/error/error.dart';

enum UserRole {
  ownerCompany,
  managerCompany,
  staffCompany,
  staffUnassigned,
  client;

  static UserRole fromString(String value) {
    switch (value) {
      case 'owner_company':
        return UserRole.ownerCompany;
      case 'manager_company':
        return UserRole.managerCompany;
      case 'staff_company':
        return UserRole.staffCompany;
      case 'staff_unassigned':
        return UserRole.staffUnassigned;
      case 'client':
        return UserRole.client;
      default:
        throw ParsingException('Unknown UserRole: $value');
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
      case UserRole.staffUnassigned:
        return 'Unassigned Staff';
      case UserRole.client:
        return 'Client';
    }
  }

  String get routePrefix {
    switch (this) {
      case UserRole.ownerCompany:
        return 'owner';
      case UserRole.managerCompany:
        return 'manager';
      case UserRole.staffCompany:
        return 'staff';
      case UserRole.staffUnassigned:
        return 'unassigned-staff';
      case UserRole.client:
        return 'client';
    }
  }

  /// Override toString biar tampil human readable di UI juga
  @override
  String toString() => displayName;
}