import 'package:workorder_company_app/features/auth/domain/entities/user_registration_entity.dart';

class UserRegistrationModel extends UserRegistrationEntity {
  UserRegistrationModel(
      {required super.name,
      required super.email,
      required super.role,
      required super.password});

  factory UserRegistrationModel.fromEntity(UserRegistrationEntity entity) {
    return UserRegistrationModel(
      name: entity.name,
      email: entity.email,
      role: entity.role,
      password: entity.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role.toSnakeCase(),
      'password': password,
    };
  }
}
