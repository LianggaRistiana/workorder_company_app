import 'package:workorder_company_app/core/constants/app_enums.dart';

class UserRegistrationEntity {
  final String name;
  final String email;
  final UserRole role;
  final String password;

  UserRegistrationEntity({
    required this.name,
    required this.email,
    required this.role,
    required this.password,
  });
}
