import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

/// Rule that grants access if the role
/// is allowed to perform AT LEAST ONE permission.
///
/// Logical equivalent of OR (||).
///
/// Example:
/// - User may READ or CREATE CSR
class AnyOfRule implements PermissionRule {
  final List<AppPermission> permissions;

  const AnyOfRule(this.permissions);

  @override
  bool isAllowed(UserRole role) {
    return role.canAny(permissions);
  }
}