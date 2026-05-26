import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';

sealed class MembershipCodeListEvent {}

class GetMembershipCodeListRequested extends MembershipCodeListEvent {}

class AddMembershipCodeRequested extends MembershipCodeListEvent {
  final List<MembershipCodeEntity> codes;

  AddMembershipCodeRequested(this.codes);
}

class DeleteMembershipCodeRequested extends MembershipCodeListEvent {
  final String id;

  DeleteMembershipCodeRequested(this.id);
}
