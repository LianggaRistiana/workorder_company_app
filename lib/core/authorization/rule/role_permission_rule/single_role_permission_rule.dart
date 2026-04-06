import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/util/check_permission.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// A role-based [AuthorizationRule] that requires a single
/// [AppPermission] to be granted.
///
/// This rule evaluates whether the user's role contains
/// the specified [permission]. Authorization succeeds only
/// if that permission is present.
///
/// This represents the most basic form of role-based
/// authorization and is typically used when an action
/// depends on exactly one required permission.
///
/// Example:
/// ```dart
/// SingleRolePermissionRule(AppPermission.workOrderAssign);
/// ```
///
/// In this case, the user must have the `workOrderAssign`
/// permission to be authorized.
///
/// Notes:
/// - Evaluation is delegated to the role's permission logic.
/// - Access is denied if the permission is not granted.
/// - The denial result contains a generic authorization message.
class SingleRolePermissionRule implements AuthorizationRule {
  final AppPermission permission;

  const SingleRolePermissionRule(this.permission);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final hasPermission = user.role.canPermission(permission);

    if (!hasPermission) {
      return AuthorizationResult.denied(
        "Anda tidak memiliki izin untuk melakukan aksi ini.",
      );
    }

    return const AuthorizationResult.allowed();
  }
}
