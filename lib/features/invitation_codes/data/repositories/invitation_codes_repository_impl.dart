import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/invitation_codes/data/datasources/invitation_codes_remote_datasource.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_draft_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_preview_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/repositories/invitation_codes_repository.dart';


class InvitationCodesRepositoryImpl implements InvitationCodesRepository {
  final InvitationCodesRemoteDatasource _datasource;

  InvitationCodesRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<InvitationCodeEntity>>> getInvitationCodes() {
    return safeCall(() async {
      final response = await _datasource.getInvitationCodes();
      return response.data;
    });
  }

  @override
  Future<Either<Failure, InvitationCodeEntity>> getInvitationCodeById(String id) {
    return safeCall(() async {
      final response = await _datasource.getInvitationCodeById(id);
      return response.data;
    });
  }

  @override
  Future<Either<Failure, InvitationCodeEntity>> createInvitationCode(
    InvitationCodeDraftEntity draft,
  ) {
    return safeCall(() async {
      final body = _draftToJson(draft);
      final response = await _datasource.createInvitationCode(body);
      return response.data;
    });
  }

  @override
  Future<Either<Failure, InvitationCodeEntity>> updateInvitationCode(
    String id,
    InvitationCodeDraftEntity draft,
  ) {
    return safeCall(() async {
      final body = _draftToJson(draft);
      final response = await _datasource.updateInvitationCode(id, body);
      return response.data;
    });
  }

  @override
  Future<Either<Failure, void>> revokeInvitationCode(String id) {
    return safeCall(() async {
      await _datasource.revokeInvitationCode(id);
    });
  }

  @override
  Future<Either<Failure, InvitationCodePreviewEntity>> previewInvitationCode(String code) {
    return safeCall(() async {
      final response = await _datasource.previewInvitationCode(code);
      return response.data;
    });
  }

  @override
  Future<Either<Failure, void>> claimInvitationCode(String code) {
    return safeCall(() async {
      await _datasource.claimInvitationCode(code);
    });
  }


  Map<String, dynamic> _draftToJson(InvitationCodeDraftEntity draft) {
    final body = <String, dynamic>{'role': draft.role.toSnakeCase()};
    if (draft.positionId != null) body['positionId'] = draft.positionId;
    if (draft.customCode != null) body['code'] = draft.customCode;
    if (draft.maxUses != null) body['maxUses'] = draft.maxUses;
    if (draft.expiresInDays != null) body['expiresInDays'] = draft.expiresInDays;
    return body;
  }
}
