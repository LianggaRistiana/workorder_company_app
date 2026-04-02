import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

/// Represents an authorization rule that determines
/// whether a [UserRole] is allowed to perform an action.
///
/// ## Purpose
/// [PermissionRule] encapsulates **authorization logic**
/// beyond simple permission ownership.
///
/// This abstraction allows permission checks to evolve from:
///
/// - simple role → permission mapping
/// - to complex business policies
///
/// without changing UI, routing, or guards.
///
/// ## Why not check permissions directly?
/// Direct permission checks (e.g. `role.has(permission)`)
/// only answer:
/// > "Does the role structurally own this permission?"
///
/// While [PermissionRule] answers:
/// > "Is the role allowed to perform this action **now**?"
///
/// ## Typical use cases
/// - Require **multiple permissions** (AND / OR)
/// - Apply **business rules**
/// - Apply **conditional logic**
///   (ownership, status, environment, time, etc.)
///
/// ## Examples
///
/// ### Single permission
/// ```dart
/// PermissionRule rule =
///   SinglePermissionRule(workOrderAssign);
///
/// rule.isAllowed(user.role);
/// ```
///
/// ### Multiple permissions (ALL)
/// ```dart
/// PermissionRule rule = AllOfRule([
///   workOrderRead,
///   workOrderAssign,
/// ]);
/// ```
///
/// ### Multiple permissions (ANY)
/// ```dart
/// PermissionRule rule = AnyOfRule([
///   csrRead,
///   csrCreate,
/// ]);
/// ```
///
/// ## Architectural rule
/// - UI, Route Guards, and Widgets **MUST NOT**
///   check permissions directly
/// - They should depend only on [PermissionRule]
///
/// This ensures:
/// - Single authorization entry point
/// - Policy consistency
/// - Future-proof permission system
abstract class PermissionRule {
  /// Evaluates whether the given [user]
  /// satisfies this authorization rule.
  ///
  /// Returns `true` if access is granted,
  /// otherwise `false`.
  bool isAllowed(UserEntity user);
}
