import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';

class GetMembershipCodesUsecase {
  final MembershipsRepository _repository;

  GetMembershipCodesUsecase(this._repository);

  Future<Either<Failure, List<MembershipCodeEntity>>> call() async {
    return await _repository.getMembershipCodes();
  }
}
