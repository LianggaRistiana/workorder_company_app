import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_entity.dart';

class MembershipModel extends MembershipEntity {
  const MembershipModel(
      {required super.id,
      required super.code,
      required super.isClaimed,
      required super.claimedBy,
      super.claimedAt,
      required super.createdAt,
      super.updatedAt,
      super.deletedAt});

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      id: safeParse<String>(json, "_id"),
      code: safeParse<String>(json, "code"),
      isClaimed: safeParse<bool>(json, "isClaimed"),
      claimedBy: UserModel.fromJson(
          safeParse<Map<String, dynamic>>(json, "claimedBy")),
      claimedAt: safeParse<DateTime?>(
        json,
        "claimedAt",
        requiredField: false,
        parser: (value) => DateTime.parse(value as String),
      ),
      createdAt: safeParse<DateTime>(
        json,
        "createdAt",
        requiredField: false,
        parser: (value) => DateTime.parse(value as String),
      ),
      updatedAt: safeParse<DateTime?>(
        json,
        "updatedAt",
        requiredField: false,
        parser: (value) => DateTime.parse(value as String),
      ),
      deletedAt: safeParse<DateTime?>(
        json,
        "deletedAt",
        requiredField: false,
        parser: (value) => DateTime.parse(value as String),
      ),
    );
  }
}
