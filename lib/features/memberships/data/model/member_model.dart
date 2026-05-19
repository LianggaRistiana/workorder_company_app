import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';
import 'package:workorder_company_app/features/system_integration/data/model/external_user_model.dart';

class MemberModel extends MemberEntity {
  const MemberModel({
    required super.externalUser,
    required super.client,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      externalUser:
          json.field("external_account").reqModel(ExternalUserModel.fromJson),
      client: UserModel.fromJson(json['user']),
    );
  }
}
