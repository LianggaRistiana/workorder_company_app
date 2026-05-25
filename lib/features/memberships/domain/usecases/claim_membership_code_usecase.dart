import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';

class ClaimMembershipCodeUsecase {
  final MembershipsRepository _repository;

  ClaimMembershipCodeUsecase(this._repository);

  Future<Either<Failure, ExternalUserEntity>> call(
      String token, String companyId) async {
    return await _repository.claimMembership(
      token,
      companyId,
    );
  }
}
