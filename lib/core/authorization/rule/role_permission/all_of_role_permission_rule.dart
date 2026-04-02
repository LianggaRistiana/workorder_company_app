import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// A [PermissionRule] that checks if a user's role has **all** of the specified permissions.
///
/// This rule grants access only if the user possesses **every** permission in [permissions].
/// It is useful for actions that require multiple permissions to be satisfied simultaneously.
///
/// The check is performed via `user.role.canAll`, ensuring that authorization logic
/// is centralized and consistent across the application.
class AllOfRolePermissionRule implements PermissionRule {
  /// The list of permissions that must all be granted to the user's role.
  final List<AppPermission> permissions;

  const AllOfRolePermissionRule(this.permissions);

  @override
  bool isAllowed(UserEntity user) {
    return user.role.canAll(permissions);
  }
}