import 'package:workorder_company_app/features/memberships/domain/entitties/membership_codes_generate_draft_entity.dart';

class MembershipCodeGenerateDraftModel
    extends MembershipCodesGenerateDraftEntity {
  const MembershipCodeGenerateDraftModel({
    required super.amount,
    required super.preffix,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'preffix': preffix,
    };
  }
}
