import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_summary_entity.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

// consider to separate this entity with to type of invitation entity or tell backend to send similiar data to sender and receiver
class InvitationEntity {
  final String id;
  final UserRole role;
  final InvitationStatus status;
  final CompanyEntity company;
  final PositionEntity? position;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;
  final UserSummaryEntity? toUser;

  InvitationEntity({
    required this.id,
    required this.role,
    required this.status,
    required this.company,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.expiresAt,
    this.toUser,
  });
}
