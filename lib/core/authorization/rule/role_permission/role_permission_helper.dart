import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission/all_of_role_permission_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission/any_of_role_permission_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission/single_role_permission_rule.dart';

/// Creates a [PermissionRule] that checks if the user's role has a single permission.
/// Use this for actions that require one specific permission.
PermissionRule roleCan(AppPermission permission) =>
    SingleRolePermissionRule(permission);

/// Creates a [PermissionRule] that checks if the user's role has **all** permissions
/// in the given list.
/// Use this for actions that require multiple permissions to be satisfied simultaneously.
PermissionRule roleCanAll(List<AppPermission> permissions) =>
    AllOfRolePermissionRule(permissions);

/// Creates a [PermissionRule] that checks if the user's role has **at least one** permission
/// in the given list.
/// Use this for actions where any one permission is sufficient.
PermissionRule roleCanAny(List<AppPermission> permissions) =>
    AnyOfRolePermissionRule(permissions);
