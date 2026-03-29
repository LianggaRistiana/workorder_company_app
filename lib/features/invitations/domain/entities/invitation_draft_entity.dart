import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class InvitationDraftEntity {
  final String? id; // JUST FOR UI KEY
  final String email;
  final UserRole role;
  final PositionEntity? position;

  InvitationDraftEntity({
    this.id,
    required this.email,
    required this.role,
    this.position,
  }) ;

  InvitationDraftEntity copyWith({
    String? email,
    UserRole? role,
    PositionEntity? position,
  }) {
    return InvitationDraftEntity(
      email: email ?? this.email,
      role: role ?? this.role,
      position: position ?? this.position,
    );
  }
}
