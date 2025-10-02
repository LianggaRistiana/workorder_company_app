import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class InvitationEntity{
  final UserEntity user;
  final String roleOffered;
  final PositionEntity? positionOffered;

  InvitationEntity({required this.user, required this.roleOffered,  this.positionOffered});
}