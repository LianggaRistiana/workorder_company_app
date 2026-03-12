import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_summary_entity.dart';

class UserSummaryModel extends UserSummaryEntity {
  const UserSummaryModel({
    required super.name,
    required super.email,
  });

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSummaryModel(
      name: safeParse<String>(json, "name"),
      email: safeParse<String>(json, "email"),
    );
  }
}
