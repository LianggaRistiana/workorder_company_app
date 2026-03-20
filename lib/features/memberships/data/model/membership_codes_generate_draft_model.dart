import 'package:workorder_company_app/features/memberships/domain/entitties/membership_codes_generate_draft_entity.dart';


class MembershipCodesGenerateDraftModel
    extends MembershipCodesGenerateDraftEntity {
  const MembershipCodesGenerateDraftModel({
    required super.amount,
    required super.prefix,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'prefix': prefix,
    };
  }

  factory MembershipCodesGenerateDraftModel.fromEntity(
      MembershipCodesGenerateDraftEntity entity) {
    return MembershipCodesGenerateDraftModel(
      amount: entity.amount,
      prefix: entity.prefix,
    );
  }
}
