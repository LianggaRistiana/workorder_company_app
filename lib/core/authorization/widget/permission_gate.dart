import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';

/// A widget that conditionally renders its [child] based on a [PermissionRule].
///
/// [PermissionGate] evaluates a [PermissionRule] against the current authenticated
/// user (from [AuthBloc]). If the rule passes, the [child] is rendered.
/// Otherwise, an optional [fallback] widget is displayed (defaults to nothing).
///
/// This centralizes permission-based UI control, keeping UI code clean
/// and consistent with your authorization logic.
///
/// Example usage:
/// ```dart
/// PermissionGate(
///   rule: roleCan(AppPermission.workOrderAssign),
///   child: ElevatedButton(
///     onPressed: () {},
///     child: const Text('Assign Work Order'),
///   ),
///   fallback: const Text('Access Denied'),
/// )
/// ```
///
/// ## Notes
/// - The rule can be any implementation of [PermissionRule], including
///   custom rules that depend on user attributes, context, or business logic.
/// - For convenience, you can use your previously defined `.require()` extension
///   to wrap a widget instead of explicitly creating a `PermissionGate`.
/// - Avoid checking permissions directly in the UI; always go through [PermissionGate].
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

    final user = state.user;
    final allowed = rule.isAllowed(user);

    return allowed ? child : (fallback ?? const SizedBox.shrink());
  }
}