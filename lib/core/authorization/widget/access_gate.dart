import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';

/// A widget that conditionally renders its [child] based on an [AuthorizationRule].
///
/// [AccessGate] evaluates the provided [rule] against the currently
/// authenticated user (from [AuthBloc]).
///
/// If the rule evaluation result is allowed, the [child] is rendered.
/// Otherwise, an optional [fallback] widget is displayed.
/// If no [fallback] is provided, nothing is rendered.
///
/// This widget centralizes authorization-based UI control,
/// preventing authorization logic from being scattered across
/// the presentation layer.
///
/// Example:
/// ```dart
/// AccessGate(
///   rule: PermissionRule(AppPermission.workOrderAssign),
///   child: ElevatedButton(
///     onPressed: () {},
///     child: const Text('Assign Work Order'),
///   ),
///   fallback: const Text('Access Denied'),
/// )
/// ```
///
/// Shortcut:
/// You can also use the `.require()` extension on any widget
/// for a more concise syntax:
///
/// ```dart
/// ElevatedButton(
///   onPressed: () {},
///   child: const Text('Assign Work Order'),
/// ).require(roleCan(AppPermission.workOrderAssign));
/// ```
///
/// Notes:
/// - The rule must implement [AuthorizationRule].
/// - The [evaluate] method is responsible for returning an authorization result.
/// - If the user is not authenticated, the [fallback] is rendered.
/// - Keep authorization logic inside rules, not inside UI widgets.

class AccessGate extends StatelessWidget {
  final AuthorizationRule rule;

  final Widget child;

  final Widget? fallback;

  const AccessGate({
    super.key,
    required this.rule,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;

    if (state is! Authenticated) {
      return fallback ?? const SizedBox.shrink();
    }

    final user = state.user;
    final result = rule.evaluate(user);

    return result.isAllowed ? child : (fallback ?? const SizedBox.shrink());
  }
}
