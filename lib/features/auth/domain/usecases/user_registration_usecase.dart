import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_registration_entity.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class UserRegistrationUsecase {
  final AuthRepository repository;

  UserRegistrationUsecase(this.repository);

  Future<Either<Failure, void>> call(UserRegistrationEntity user) async {
    return repository.userRegistration(user);
  }
}
