import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/auth/domain/entities/base_user_entity.dart';

class UserSummaryEntity extends Equatable implements BaseUserEntity {
  @override
  final String name;
  @override
  final String email;

  const UserSummaryEntity({
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [
        name,
        email,
      ];
}
