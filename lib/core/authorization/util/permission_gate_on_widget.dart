import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';

/// Extension on [Widget] to simplify wrapping widgets with a [PermissionGate].
///
/// This allows any widget to be conditionally rendered based on a
/// [PermissionRule] without manually creating a [PermissionGate].
///
/// Example usage:
/// ```dart
/// ElevatedButton(
///   onPressed: () {},
///   child: const Text('Assign Work Order'),
/// ).require(
///   roleCan(AppPermission.workOrderAssign),
///   fallback: const Text('Access Denied'),
/// );
/// ```
///
/// Notes:
/// - [rule] can be any implementation of [PermissionRule], including
///   role-based rules (`roleCan`, `roleCanAll`, `roleCanAny`) or custom
///   contextual rules.
/// - [fallback] is optional and defaults to an empty widget (`SizedBox.shrink()`).
/// - Using this extension keeps UI code clean and consistent with your
///   authorization logic.
extension PermissionGateX on Widget {
  /// Wraps this widget with a [PermissionGate] to conditionally render
  /// it based on [rule].
  ///
  /// [rule] defines the authorization logic.
  /// [fallback] is displayed if the rule is not satisfied.
  Widget require(PermissionRule rule, {Widget? fallback}) {
    return PermissionGate(
      rule: rule,
      fallback: fallback,
      child: this,
    );
  }
}
