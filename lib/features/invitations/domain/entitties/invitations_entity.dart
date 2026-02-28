import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class InvitationsEntity {
  String email;
  UserRole role;
  PositionEntity? position;

  InvitationsEntity({
    required this.email,
    required this.role,
    this.position,
  });
}
