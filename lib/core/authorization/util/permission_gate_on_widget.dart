import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/rule/permission_rule.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';

/// Extension on [Widget] to simplify applying [PermissionGate].
///
/// This allows any widget to declaratively require a permission rule
/// before rendering, keeping UI code clean and readable.
///
/// Instead of wrapping a widget manually with [PermissionGate]:
/// ```dart
/// PermissionGate(
///   rule: allow(AppPermission.workOrderAssign),
///   child: AssignButton(),
/// )
/// ```
///
/// You can use the `require` extension:
/// ```dart
/// AssignButton().require(
///   allow(AppPermission.workOrderAssign),
/// )
/// ```
///
/// ## Parameters
/// - [rule]: The [PermissionRule] to evaluate for the current user's role.
/// - [fallback] (optional): Widget to render if the user is not authorized.
///   Defaults to [SizedBox.shrink] (renders nothing).
///
/// ## Advantages
/// - Makes UI code more concise and readable
/// - Keeps permission checks centralized in [PermissionRule]
/// - Easily composable in widget trees without nesting
///
/// ## Examples
///
/// ### Single Permission
/// ```dart
/// ElevatedButton(
///   onPressed: () {},
///   child: const Text('Assign Work Order'),
/// ).require(
///   allow(AppPermission.workOrderAssign),
/// )
/// ```
///
/// ### Multiple Permissions (ALL)
/// ```dart
/// AssignButton().require(
///   allOf([
///     AppPermission.workOrderRead,
///     AppPermission.workOrderAssign,
///   ]),
/// )
/// ```
///
/// ### Fallback Widget
/// ```dart
/// AssignButton().require(
///   allow(AppPermission.workOrderAssign),
///   fallback: const Text('Not allowed'),
/// )
/// ```
extension PermissionGateX on Widget {
  /// Wraps this widget with a [PermissionGate] to conditionally render
  /// it based on [rule].
  Widget require(PermissionRule rule, {Widget? fallback}) {
    return PermissionGate(
      rule: rule,
      fallback: fallback,
      child: this,
    );
  }
}