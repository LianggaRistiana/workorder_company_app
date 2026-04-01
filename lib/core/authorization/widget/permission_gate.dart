import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';

/// A reusable widget that conditionally renders its [child]
/// based on the current user's permissions or business rules.
///
/// [PermissionGate] listens to [AuthBloc] and evaluates a
/// [PermissionRule] to determine if the user is allowed to access
/// the widget.
///
/// This widget is designed to:
/// - Centralize permission-based UI access control
/// - Prevent unauthorized users from seeing or interacting
///   with restricted UI components
/// - Keep UI code clean, declarative, and maintainable
///
/// ## Usage
///
/// ### Single Permission
/// ```dart
/// PermissionGate(
///   rule: allow(AppPermission.workOrderAssign),
///   child: ElevatedButton(
///     onPressed: () {},
///     child: const Text('Assign Work Order'),
///   ),
/// )
/// ```
///
/// ### Multiple Permissions (ALL required)
/// ```dart
/// PermissionGate(
///   rule: allOf([
///     AppPermission.workOrderRead,
///     AppPermission.workOrderAssign,
///   ]),
///   child: AssignButton(),
/// )
/// ```
///
/// ### Multiple Permissions (ANY required)
/// ```dart
/// PermissionGate(
///   rule: anyOf([
///     AppPermission.csrRead,
///     AppPermission.csrCreate,
///   ]),
///   child: CsrButton(),
/// )
/// ```
///
/// ### Fallback UI
/// You can provide a widget to render if the user is not authorized:
/// ```dart
/// PermissionGate(
///   rule: allow(AppPermission.workOrderAssign),
///   child: AssignButton(),
///   fallback: const Text('Not allowed'),
/// )
/// ```
class PermissionGate extends StatelessWidget {
  /// The permission rule to evaluate.
  final PermissionRule rule;

  /// The widget to render if the user passes the [rule].
  final Widget child;

  /// Optional widget to render if the user fails the [rule].
  /// Defaults to [SizedBox.shrink] (renders nothing).
  final Widget? fallback;

  const PermissionGate({
    super.key,
    required this.rule,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;

    // If the user is not authenticated, show fallback
    if (state is! Authenticated) {
      return fallback ?? const SizedBox.shrink();
    }

    final role = state.user.role;
    final allowed = rule.isAllowed(role);

    return allowed ? child : (fallback ?? const SizedBox.shrink());
  }
}
