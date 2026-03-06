import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_registration_entity.dart';
import 'package:workorder_company_app/features/auth/domain/policy/user_registration_policy.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class UserRegistrationUsecase {
  final AuthRepository repository;
  final UserRegistrationPolicy policy;

  UserRegistrationUsecase(this.repository, this.policy);

  Future<Either<Failure, void>> call(UserRegistrationEntity user) async {
    final policyResult = policy.validate(user);
    if (policyResult.isError) {
      return Left(PolicyFailure(policyResult.issue!));
    } else {
      return repository.userRegistration(user);
    }
  }
}
