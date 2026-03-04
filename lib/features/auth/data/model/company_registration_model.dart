import 'package:workorder_company_app/features/auth/domain/entities/company_registration_entity.dart';

class CompanyRegistrationModel extends CompanyRegistrationEntity {
  CompanyRegistrationModel({
    required super.name,
    required super.email,
    required super.password,
    required super.companyName,
  });

  factory CompanyRegistrationModel.fromEntity(
      CompanyRegistrationEntity entity) {
    return CompanyRegistrationModel(
      name: entity.name,
      email: entity.email,
      password: entity.password,
      companyName: entity.companyName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'companyName': companyName,
    };
  }
}
