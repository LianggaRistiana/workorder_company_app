import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/position_permission_rule/position_permission_helper.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

class SenderInviteAuthorizer {
  AuthorizationRule get managerInvitationRule => _ManagerInviteRule();
  AuthorizationRule get configPositionRule => hasNoPosition();
}

class _ManagerInviteRule implements AuthorizationRule {
  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (user.role == UserRole.ownerCompany) {
      return AuthorizationResult.allowed();
    }
    return AuthorizationResult.denied("Tidak dapat mengundang manager");
  }
}
