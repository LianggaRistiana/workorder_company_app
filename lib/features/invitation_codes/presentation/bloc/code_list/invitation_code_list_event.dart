abstract class InvitationCodeListEvent {
  const InvitationCodeListEvent();
}

class GetInvitationCodeList extends InvitationCodeListEvent {
  const GetInvitationCodeList();
}

class RemoveInvitationCodeFromList extends InvitationCodeListEvent {
  final String id;
  const RemoveInvitationCodeFromList(this.id);
}

class AddInvitationCodeToList extends InvitationCodeListEvent {
  final dynamic code;
  const AddInvitationCodeToList(this.code);
}

class UpdateInvitationCodeInList extends InvitationCodeListEvent {
  final dynamic code;
  const UpdateInvitationCodeInList(this.code);
}
