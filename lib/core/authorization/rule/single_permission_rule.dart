import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// Rule that grants access if the role
/// is allowed to perform a single permission.
///
/// This is the most basic authorization rule
/// and acts as a wrapper around `role.canPermission`.
///
/// Use this rule when:
/// - A route or feature requires exactly ONE permission
/// - You want future policy logic to stay centralized
class SinglePermissionRule implements PermissionRule {
  final AppPermission permission;

  const SinglePermissionRule(this.permission);

  @override
  bool isAllowed(UserEntity user) {
    return user.role.canPermission(permission);
  }
}
