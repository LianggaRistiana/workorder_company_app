import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';

class MembershipCodeModel extends MembershipCodeEntity {
  const MembershipCodeModel({
    required super.id,
    required super.token,
    required super.externalCustomerEmail,
    required super.externalCustomerName,
    super.claimedAt,
  });

  factory MembershipCodeModel.fromJson(Map<String, dynamic> json) {
    return MembershipCodeModel(
      id: json.field("_id").reqString(),
      token: json.field("token").reqString(),
      externalCustomerEmail: json.field("externalCustomerEmail").reqString(),
      externalCustomerName: json.field("externalCustomerName").reqString(),
      claimedAt: json.field("claimedAt").optDate(),
    );
  }
}
