import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_draft_entity.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';

abstract class InvitationsRepository {
  Future<Either<Failure, List<InvitationEntity>>> getInvitationsHistory();
  Future<Either<Failure, List<InvitationEntity>>> inviteEmployees(
    List<InvitationDraftEntity> invitationsData,
  );
  Future<Either<Failure, InvitationEntity>> acceptInvitation(String id);
  Future<Either<Failure, InvitationEntity>> rejectInvitation(String id);
  Future<Either<Failure, InvitationEntity>> cancelInvitation(String id);
}
