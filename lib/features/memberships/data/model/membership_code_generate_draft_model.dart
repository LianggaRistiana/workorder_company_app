import 'package:workorder_company_app/features/memberships/domain/entitties/membership_codes_generate_draft_entity.dart';


// FIXME : prefffix => prefix, 'ad' s after 'code'
class MembershipCodeGenerateDraftModel
    extends MembershipCodesGenerateDraftEntity {
  const MembershipCodeGenerateDraftModel({
    required super.amount,
    required super.preffix,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'prefix': preffix,
    };
  }

  factory MembershipCodeGenerateDraftModel.fromEntity(
      MembershipCodesGenerateDraftEntity entity) {
    return MembershipCodeGenerateDraftModel(
      amount: entity.amount,
      preffix: entity.preffix,
    );
  }
}
