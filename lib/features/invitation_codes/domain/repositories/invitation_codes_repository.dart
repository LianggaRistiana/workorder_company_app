import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_draft_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_preview_entity.dart';

abstract class InvitationCodesRepository {
  // Company side
  Future<Either<Failure, List<InvitationCodeEntity>>> getInvitationCodes();
  Future<Either<Failure, InvitationCodeEntity>> getInvitationCodeById(String id);
  Future<Either<Failure, InvitationCodeEntity>> createInvitationCode(InvitationCodeDraftEntity draft);
  Future<Either<Failure, InvitationCodeEntity>> updateInvitationCode(String id, InvitationCodeDraftEntity draft);
  Future<Either<Failure, void>> revokeInvitationCode(String id);

  // Employee side
  Future<Either<Failure, InvitationCodePreviewEntity>> previewInvitationCode(String code);
  Future<Either<Failure, void>> claimInvitationCode(String code);
}
