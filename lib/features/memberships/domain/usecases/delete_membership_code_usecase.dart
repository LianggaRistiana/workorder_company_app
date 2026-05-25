import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';

class DeleteMembershipCodeUsecase {
  final MembershipsRepository _repository;

  DeleteMembershipCodeUsecase(this._repository);

  FutureEither<MembershipCodeEntity> call(String id) async {
    return await _repository.deleteMembership(id);
  }
}
