// import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

// /// Represents a single **authorization rule** for an action.
// ///
// /// Each [PermissionRule] instance defines **one rule**.
// /// One action may require multiple rules to be satisfied.
// /// In that case, combine them using `ConditionEvaluator` (`allOf` / `anyOf`).
// ///
// /// Rules can depend on:
// /// - User role and permissions
// /// - User-specific attributes (e.g., email, department)
// /// - Object context (e.g., status, ownership)
// ///
// /// Example: cancel service request
// /// ```dart
// /// class _CancelServiceRequestRule extends PermissionRule {
// ///   final RequesterServiceRequestEntity request;
// ///
// ///   _CancelServiceRequestRule({required this.request});
// ///
// ///   @override
// ///   bool isAllowed(UserEntity user) {
// ///     return allOf([
// ///       () => user.role.canPermission(ServiceRequestPermission.cancel),
// ///       () => request.status == ServiceRequestStatus.received,
// ///       () => request.requestedBy.email == user.email,
// ///     ]);
// ///   }
// /// }
// /// ```
// abstract class PermissionRule {
//   /// Evaluates whether the given [user] satisfies this rule.
//   ///
//   /// Returns `true` if access is allowed, otherwise `false`.
//   bool isAllowed(UserEntity user);
// }
