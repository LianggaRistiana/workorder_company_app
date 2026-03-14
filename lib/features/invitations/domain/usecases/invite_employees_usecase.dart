import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_draft_entity.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/features/invitations/domain/repositories/invitations_repository.dart';

class InviteEmployeesUsecase {
  final InvitationsRepository _repository;

  InviteEmployeesUsecase(this._repository);

  Future<Either<Failure, List<InvitationEntity>>> call(
    List<InvitationDraftEntity> invitationsData,
  ) async {
    return await _repository.inviteEmployees(invitationsData);
  }
}
