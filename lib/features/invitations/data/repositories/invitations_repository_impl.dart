import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/invitations/data/datasources/receiver_invitations_remote_datasource.dart';
import 'package:workorder_company_app/features/invitations/data/datasources/sender_invitations_remote_datasource.dart';
import 'package:workorder_company_app/features/invitations/data/model/invitation_draft_model.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_draft_entity.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/features/invitations/domain/repositories/invitations_repository.dart';

class InvitationsRepositoryImpl implements InvitationsRepository {
  final ReceiverInvitationsRemoteDatasource _receiverRemoteDataSource;
  final SenderInvitationsRemoteDatasource _senderRemoteDatasource;

  InvitationsRepositoryImpl(
      this._receiverRemoteDataSource, this._senderRemoteDatasource);

  @override
  Future<Either<Failure, InvitationEntity>> acceptInvitation(String id) {
    // TODO: implement acceptInvitation
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, InvitationEntity>> cancelInvitation(String id) {
    return safeCall(() async {
      final payload = await _senderRemoteDatasource.cancelInvitation(id);
      return payload.data!;
    });
  }

  @override
  Future<Either<Failure, List<InvitationEntity>>> getInvitationsHistory() {
    return safeCall(() async {
      final payload = await _senderRemoteDatasource.getInvitationsHistory();
      return payload.data ?? [];
    });
  }

  @override
  Future<Either<Failure, List<InvitationEntity>>> inviteEmployees(
      List<InvitationDraftEntity> invitationsData) {
    return safeCall(() async {
      final payload = await _senderRemoteDatasource.inviteEmployees(
          invitationsData
              .map((e) => InvitationDraftModel.fromEntity(e))
              .toList());
      return payload.data ?? [];
    });
  }

  @override
  Future<Either<Failure, InvitationEntity>> rejectInvitation(String id) {
    // TODO: implement rejectInvitation
    throw UnimplementedError();
  }
}
