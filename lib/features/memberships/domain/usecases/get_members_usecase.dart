import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';

class GetMembersUsecase {
  final MembershipsRepository _repository;

  GetMembersUsecase(this._repository);

  FutureEitherList<MemberEntity> call() {
    return _repository.getMembers();
  }
}
