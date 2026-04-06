import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/composite/composite_rule.dart';

/// Creates a composite [AuthorizationRule] that combines multiple rules
/// using logical AND semantics.
///
/// This is a convenience factory for [CompositeRule], allowing
/// more expressive and readable authorization definitions.
///
/// All provided [rules] must grant access for the resulting rule
/// to be allowed. Evaluation follows a fail-fast strategy:
/// the first rule that denies access determines the final result.
///
/// Example:
/// ```dart
/// rules([
///   roleCan(AppPermission.workOrderAssign),
///   SubscriptionActiveRule(),
///   CompanyScopeRule(companyId),
/// ]);
/// ```
///
/// Notes:
/// - Rules are evaluated in order.
/// - Access is granted only if all rules are allowed.
/// - If any rule denies access, evaluation stops immediately.
AuthorizationRule rules(List<AuthorizationRule> rules) => CompositeRule(rules);
