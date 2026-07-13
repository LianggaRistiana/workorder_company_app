import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

/// Preview entity returned by GET /invitation-codes/:code (employee side)
class InvitationCodePreviewEntity {
  final String code;
  final CompanyEntity? company;
  final UserRole role;
  final PositionEntity? position;
  final DateTime? expiresAt;

  const InvitationCodePreviewEntity({
    required this.code,
    this.company,
    required this.role,
    this.position,
    this.expiresAt,
  });

  String get roleDisplayName => role.displayName;
}
