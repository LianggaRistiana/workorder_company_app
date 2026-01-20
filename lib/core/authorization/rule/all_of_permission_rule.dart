import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

/// Rule that grants access only if the role
/// is allowed to perform ALL given permissions.
///
/// Logical equivalent of AND (&&).
///
/// Example:
/// - User must be able to READ and ASSIGN work orders
class AllOfRule implements PermissionRule {
  final List<AppPermission> permissions;

  const AllOfRule(this.permissions);

  @override
  bool isAllowed(UserRole role) {
    return role.canAll(permissions);
  }
}