import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';

class MemberModel extends MemberEntity {
  MemberModel(
      {required super.membershipCode,
      required super.claimedAt,
      required super.client});

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      membershipCode: json['membershipCode'],
      claimedAt: DateTime.parse(json['claimedAt']),
      client: UserModel.fromJson(json['client']),
    );
  }
}
