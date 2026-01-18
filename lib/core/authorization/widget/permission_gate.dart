import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/role_map/role_permission_map.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';

/// A reusable widget that conditionally renders its [child]
/// based on the current user's permission.
///
/// [PermissionGate] listens to [AuthBloc] and checks whether
/// the authenticated user owns the required [AppPermission].
///
/// This widget is designed to:
/// - Centralize permission-based UI access control
/// - Prevent unauthorized users from seeing or interacting
///   with restricted UI components
/// - Keep UI code clean and declarative
///
/// Typical use cases:
/// - Hide action buttons (create, update, approve, assign)
/// - Restrict access to sensitive sections or widgets
/// - Provide graceful fallback UI for unauthorized users
///
/// Example:
/// ```dart
/// PermissionGate(
///   permission: WorkOrderPermissions.assign,
///   child: ElevatedButton(
///     onPressed: () {},
///     child: const Text('Assign Work Order'),
///   ),
///   fallback: const SizedBox.shrink(),
/// )
/// ```
class PermissionGate extends StatelessWidget {
  final AppPermission permission;
  final Widget child;
  final Widget? fallback;

  const PermissionGate({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    if (state is! Authenticated) {
      return fallback ?? const SizedBox.shrink();
    }
    final userPermissions = state.user.role.permissions;
    final allowed = userPermissions.contains(permission);
    return allowed ? child : (fallback ?? const SizedBox.shrink());
  }
}
