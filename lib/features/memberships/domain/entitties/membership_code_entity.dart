import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_summary_entity.dart';

class MembershipCodeEntity extends Equatable {
  final String id;
  final String code;
  final bool isClaimed;
  final UserSummaryEntity? claimedBy;
  final DateTime? claimedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const MembershipCodeEntity({
    required this.id,
    required this.code,
    required this.isClaimed,
    this.claimedBy,
    this.claimedAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        isClaimed,
        claimedBy,
        claimedAt,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
