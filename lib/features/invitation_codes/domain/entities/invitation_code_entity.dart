import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_summary_entity.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class InvitationCodeEntity {
  final String id;
  final String code;
  final UserRole role;
  final CompanyEntity? company;
  final PositionEntity? position;
  final UserSummaryEntity? createdBy;
  final bool isActive;
  final int? maxUses;
  final int usedCount;
  final int? remainingUses;
  final bool isClaimable;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const InvitationCodeEntity({
    required this.id,
    required this.code,
    required this.role,
    this.company,
    this.position,
    this.createdBy,
    required this.isActive,
    this.maxUses,
    required this.usedCount,
    this.remainingUses,
    required this.isClaimable,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  String get roleDisplayName => role.displayName;

  String get usageDisplay {
    if (maxUses == null) return '$usedCount / ∞';
    return '$usedCount / $maxUses';
  }

  String localizeExpiresAt() {
    final date = expiresAt;
    if (date == null) return 'Tidak ada batas';
    return DateFormat('d MMM yyyy', 'id_ID').format(date.toLocal());
  }

  String localizeCreatedAt() {
    final date = createdAt;
    if (date == null) return '-';
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date.toLocal());
  }
}
