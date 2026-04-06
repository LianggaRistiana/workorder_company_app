import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/all_of_role_permission_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/any_of_role_permission_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/single_role_permission_rule.dart';

/// These helper functions create [AuthorizationRule] instances
/// specifically for role-based permission checks.
///
/// They provide a clean and expressive way to define authorization logic
/// without directly instantiating rule classes in the UI layer.
///
/// All rules returned here are based on the user's role permissions.
/// ---------------------------------------------------------------------------

/// Creates an [AuthorizationRule] that grants access only if
/// the user's role contains the specified [permission].
///
/// This is the most basic role-permission check.
///
/// Example:
/// ```dart
/// roleCan(AppPermission.workOrderAssign)
/// ```
AuthorizationRule roleCan(AppPermission permission) =>
    SingleRolePermissionRule(permission);

/// Creates an [AuthorizationRule] that grants access only if
/// the user's role contains **all** of the specified [permissions].
///
/// Access is denied if at least one permission is missing.
///
/// Example:
/// ```dart
/// roleCanAll([
///   AppPermission.workOrderCreate,
///   AppPermission.workOrderAssign,
/// ])
/// ```
AuthorizationRule roleCanAll(List<AppPermission> permissions) =>
    AllOfRolePermissionRule(permissions);

/// Creates an [AuthorizationRule] that grants access if
/// the user's role contains **at least one** of the specified [permissions].
///
/// Access is denied only if none of the permissions are present.
///
/// Example:
/// ```dart
/// roleCanAny([
///   AppPermission.workOrderUpdate,
///   AppPermission.workOrderDelete,
/// ])
/// ```
AuthorizationRule roleCanAny(List<AppPermission> permissions) =>
    AnyOfRolePermissionRule(permissions);
