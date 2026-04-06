import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// A [PermissionRule] that checks if a user's role has **at least one** of the specified permissions.
///
/// This rule grants access if the user possesses **any** of the permissions in [permissions].
/// It is useful for actions where multiple alternative permissions are acceptable.
///
/// The check is performed via `user.role.canAny`, ensuring that authorization logic
/// remains centralized and consistent across the app.
class AnyOfRolePermissionRule implements PermissionRule {
  /// The list of permissions to check against the user's role.
  final List<AppPermission> permissions;

  const AnyOfRolePermissionRule(this.permissions);

  @override
  bool isAllowed(UserEntity user) {
    return user.role.canAny(permissions);
  }
}