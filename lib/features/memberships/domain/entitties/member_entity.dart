import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

class MemberEntity extends Equatable {
  final String membershipCode;
  final DateTime claimedAt;
  final UserEntity client;

  const MemberEntity({
    required this.membershipCode,
    required this.claimedAt,
    required this.client,
  });
  
  @override
  List<Object?> get props => [
    membershipCode,
    claimedAt,
    client,
  ];
}
