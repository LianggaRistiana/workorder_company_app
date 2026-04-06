import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// A role-based [AuthorizationRule] that grants access if
/// the user's role contains **at least one** of the specified
/// [AppPermission]s.
///
/// This rule performs a logical OR permission check at the role level.
/// Authorization succeeds as soon as one permission in the
/// [permissions] list is granted.
///
/// This is useful when multiple permissions are considered
/// equivalent for performing the same action.
///
/// Example:
/// ```dart
/// AnyOfRolePermissionRule([
///   AppPermission.workOrderUpdate,
///   AppPermission.workOrderApprove,
/// ]);
/// ```
///
/// In this case, the user only needs one of the permissions
/// to be authorized.
///
/// Notes:
/// - Evaluation is delegated to the role's permission logic.
/// - Access is denied only if none of the permissions are present.
/// - The denial result contains a generic authorization message.
class AnyOfRolePermissionRule implements AuthorizationRule {
  final List<AppPermission> permissions;

  const AnyOfRolePermissionRule(this.permissions)
      : assert(permissions.length > 1,
            'Permissions list must have at least 2 items.');

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final hasAnyPermission = user.role.canAny(permissions);

    if (!hasAnyPermission) {
      return AuthorizationResult.denied(
        "Anda tidak memiliki izin yang diperlukan untuk melakukan aksi ini.",
      );
    }

    return const AuthorizationResult.allowed();
  }
}
