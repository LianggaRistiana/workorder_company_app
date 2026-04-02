import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission/all_of_role_permission_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission/any_of_role_permission_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission/single_role_permission_rule.dart';

PermissionRule roleCan(AppPermission permission) =>
    SingleRolePermissionRule(permission);

PermissionRule roleCanAll(List<AppPermission> permissions) =>
    AllOfRolePermissionRule(permissions);

PermissionRule roleCanAny(List<AppPermission> permissions) =>
    AnyOfRolePermissionRule(permissions);