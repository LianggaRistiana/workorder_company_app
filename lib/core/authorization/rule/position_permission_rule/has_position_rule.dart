import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

class HasPositionRule extends AuthorizationRule {
  @override
  AuthorizationResult evaluate(UserEntity user) {
    return user.position != null
        ? AuthorizationResult.allowed()
        : AuthorizationResult.denied(
            "User tidak memiliki departemen",
          );
  }
}
