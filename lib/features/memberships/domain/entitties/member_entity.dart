import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';

class MemberEntity extends Equatable {
  final UserEntity client;
  final ExternalUserEntity externalUser;

  const MemberEntity({
    required this.client,
    required this.externalUser,
  });

  @override
  List<Object?> get props => [
        client,
        externalUser,
      ];
}
