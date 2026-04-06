import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// A role-based [AuthorizationRule] that requires **all**
/// specified [AppPermission]s to be granted.
///
/// This rule evaluates whether the user's role contains every
/// permission provided in the [permissions] list.
/// Access is granted only if all permissions are present.
///
/// This represents a logical AND permission check at the role level.
///
/// Example:
/// ```dart
/// AllOfRolePermissionRule([
///   AppPermission.workOrderCreate,
///   AppPermission.workOrderAssign,
/// ]);
/// ```
///
/// In this case, the user must have both permissions
/// to be authorized.
///
/// Notes:
/// - Evaluation is delegated to the role's permission-checking logic.
/// - If any permission is missing, access is denied.
/// - The denial result contains a generic authorization message.
class AllOfRolePermissionRule implements AuthorizationRule {
  final List<AppPermission> permissions;

  const AllOfRolePermissionRule(this.permissions)
      : assert(permissions.length > 1, 'Permissions list must have at least 2 items.');

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final hasAllPermissions = user.role.canAll(permissions);

    if (!hasAllPermissions) {
      return AuthorizationResult.denied(
        "Anda tidak memiliki izin yang diperlukan untuk melakukan aksi ini.",
      );
    }

    return const AuthorizationResult.allowed();
  }
}
