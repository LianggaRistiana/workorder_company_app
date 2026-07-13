import 'package:workorder_company_app/core/constants/app_enums.dart';

/// Draft entity used when creating or updating an invitation code
class InvitationCodeDraftEntity {
  final UserRole role;
  final String? positionId;
  final String? customCode;
  final int? maxUses;
  final int? expiresInDays;

  const InvitationCodeDraftEntity({
    required this.role,
    this.positionId,
    this.customCode,
    this.maxUses,
    this.expiresInDays,
  });
}
