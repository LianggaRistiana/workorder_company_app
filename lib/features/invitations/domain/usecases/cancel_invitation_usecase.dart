import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/features/invitations/domain/repositories/invitations_repository.dart';

class CancelInvitationUsecase {
  final InvitationsRepository _repository;

  CancelInvitationUsecase(this._repository);

  Future<Either<Failure, InvitationEntity>> call(String id) async {
    return await _repository.cancelInvitation(id);
  }
}
