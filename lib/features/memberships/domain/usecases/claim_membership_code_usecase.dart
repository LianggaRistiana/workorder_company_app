import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';

class ClaimMembershipCodeUsecase {
  final MembershipsRepository _repository;

  ClaimMembershipCodeUsecase(this._repository);

  Future<Either<Failure, CompanyEntity>> call(String code) async {
    return await _repository.claimMembership(code);
  }
}
