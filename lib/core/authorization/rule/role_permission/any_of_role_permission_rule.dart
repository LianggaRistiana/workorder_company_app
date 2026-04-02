import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// Rule that grants access if the role
/// is allowed to perform AT LEAST ONE permission.
///
/// Logical equivalent of OR (||).
///
/// Example:
/// - User may READ or CREATE CSR
class AnyOfRolePermissionRule implements PermissionRule {
  final List<AppPermission> permissions;

  const AnyOfRolePermissionRule(this.permissions);

  @override
  bool isAllowed(UserEntity user) {
    return user.role.canAny(permissions);
  }
}