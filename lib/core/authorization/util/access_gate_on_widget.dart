import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/widget/access_gate.dart';

/// Adds a convenient authorization wrapper to any [Widget].
///
/// This extension allows you to declaratively protect a widget
/// using an [AuthorizationRule] without manually wrapping it
/// with an [AccessGate].
///
/// Instead of:
/// ```dart
/// AccessGate(
///   rule: rule,
///   child: MyButton(),
/// )
/// ```
///
/// You can write:
/// ```dart
/// MyButton().require(rule);
/// ```
///
/// If the rule evaluation grants access, the widget is rendered.
/// Otherwise, an optional [fallback] widget is displayed.
/// If no [fallback] is provided, nothing is rendered.
///
/// This keeps UI code concise while ensuring authorization
/// logic remains in the domain layer.
extension AccessGateOnWidget on Widget {
  Widget require(AuthorizationRule rule, {Widget? fallback}) {
    return AccessGate(
      rule: rule,
      fallback: fallback,
      child: this,
    );
  }
}
