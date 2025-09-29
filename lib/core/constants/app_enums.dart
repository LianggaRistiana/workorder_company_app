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
    return name; 
  }
}
