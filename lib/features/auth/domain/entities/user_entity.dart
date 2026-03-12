import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/base_user_entity.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class UserEntity extends Equatable implements BaseUserEntity {
  @override
  final String name;

  @override
  final String email;

  final UserRole role;
  final PositionEntity? position;

  const UserEntity({
    required this.name,
    required this.email,
    required this.role,
    this.position,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        role,
        position,
      ];
}
