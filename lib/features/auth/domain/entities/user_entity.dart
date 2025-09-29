import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class UserEntity extends Equatable {
  final String name;
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
  List<Object?> get props => [ name, email, role, position];
}
