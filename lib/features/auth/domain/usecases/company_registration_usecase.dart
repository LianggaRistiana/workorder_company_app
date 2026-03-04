import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/company_registration_entity.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class CompanyRegistrationUsecase {
  final AuthRepository repository;

  CompanyRegistrationUsecase(this.repository);

  Future<Either<Failure, void>> call(
      CompanyRegistrationEntity registrationData) async {
    return repository.companyRegistration(registrationData);
  }
}
