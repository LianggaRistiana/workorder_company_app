import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/features/invitations/domain/repositories/invitations_repository.dart';

class GetInvitationsPendingUsecase {
  final InvitationsRepository _repository;

  GetInvitationsPendingUsecase(this._repository);

  Future<Either<Failure, List<InvitationEntity>>> call() async {
    return await _repository.getPendingInvitations();
  }
}
