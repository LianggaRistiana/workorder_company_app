import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// A [PermissionRule] that checks if a user's role has a single specific permission.
///
/// Use this rule when an action requires **exactly one permission**  
/// and no additional contextual checks are needed.
///
/// This rule wraps the role's permission check (`user.role.canPermission`)  
/// so that the authorization logic stays centralized and consistent.
class SingleRolePermissionRule implements PermissionRule {
  /// The single permission required for this rule.
  final AppPermission permission;

  const SingleRolePermissionRule(this.permission);

  @override
  bool isAllowed(UserEntity user) {
    return user.role.canPermission(permission);
  }
}