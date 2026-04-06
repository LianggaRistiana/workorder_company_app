import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// A composite [AuthorizationRule] that combines multiple rules
/// using logical AND semantics.
///
/// [CompositeRule] evaluates each rule sequentially against the given user.
/// If any rule denies access, evaluation stops immediately and the
/// corresponding [AuthorizationResult] is returned (fail-fast behavior).
///
/// Access is granted only if **all** rules are allowed.
///
/// This is useful for expressing complex authorization logic, such as:
/// - User must have a specific permission
/// - AND must belong to a specific company
/// - AND must have an active subscription
///
/// Example:
/// ```dart
/// CompositeRule([
///   roleCan(AppPermission.workOrderAssign),
///   SubscriptionActiveRule(),
///   CompanyScopeRule(companyId),
/// ])
/// ```
///
/// Notes:
/// - Rules are evaluated in order.
/// - The first failing rule determines the denial result.
/// - If all rules pass, [AuthorizationResult.allowed] is returned.
class CompositeRule implements AuthorizationRule {
  final List<AuthorizationRule> rules;

  const CompositeRule(this.rules)
      : assert(rules.length > 0, 'CompositeRule requires at least one rule.');

  @override
  AuthorizationResult evaluate(UserEntity user) {
    for (final rule in rules) {
      final result = rule.evaluate(user);
      if (!result.isAllowed) return result;
    }
    return AuthorizationResult.allowed();
  }
}
