import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/role_map/role_permission_map.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

/// Permission checker for [UserRole].
///
/// -------------------------------------------------------------
/// DESIGN PRINCIPLES
/// -------------------------------------------------------------
/// - `has*` → LOW-LEVEL capability check (data ownership)
/// - `can*` → PUBLIC authorization API (policy-aware, future-proof)
///
/// RULES:
/// - UI, Route, Guard, Rule MUST ONLY use `can*`
/// - `has*` is INTERNAL and must NOT be used outside this layer
///
/// TODAY:
/// - `can*` is a thin wrapper around `has*`
///
/// FUTURE:
/// - `can*` may include:
///   - account suspension / blocking
///   - ownership validation
///   - resource or workflow status
///   - time-based access
///   - policy / business rule evaluation
///
/// This separation allows future authorization rules
/// without breaking UI, routes, or guards.
/// -------------------------------------------------------------
extension PermissionChecker on UserRole {
  // =============================================================
  // LOW LEVEL — PERMISSION OWNERSHIP
  // (INTERNAL — DO NOT USE IN UI / ROUTE / GUARD)
  // =============================================================

  /// Checks whether the role *structurally owns* a permission.
  ///
  /// Example:
  /// - Manager HAS `workorder.assign`
  /// - Staff DOES NOT have `employee.delete`
  bool has(AppPermission permission) {
    return permissions.contains(permission);
  }

  /// Checks whether the role owns ALL given permissions.
  bool hasAll(Iterable<AppPermission> permissions) {
    return permissions.every(has);
  }

  /// Checks whether the role owns ANY of the given permissions.
  bool hasAny(Iterable<AppPermission> permissions) {
    return permissions.any(has);
  }

  // =============================================================
  // PUBLIC API — POLICY AWARE AUTHORIZATION
  // (USE THIS EVERYWHERE)
  // =============================================================

  /// Checks whether the role is allowed to perform an action.
  ///
  /// This is the **SINGLE ENTRY POINT** for permission checks
  /// outside the authorization layer.
  ///
  /// TODAY:
  /// - `canPermission` == `has`
  ///
  /// FUTURE PLAN:
  /// - Account or user suspension
  /// - Ownership / contextual validation
  /// - Resource status (e.g. WorkOrder state)
  /// - Time-based or environment-based rules
  /// - Centralized policy evaluation
  ///
  /// Example future implementation:
  /// ```dart
  /// bool canPermission(AppPermission permission) {
  ///   if (isSuspended) return false;
  ///   if (!has(permission)) return false;
  ///   // additional policy checks
  ///   return true;
  /// }
  /// ```
  bool canPermission(AppPermission permission) {
    return has(permission);
  }

  /// Checks whether the role is allowed to perform ALL permissions.
  bool canAll(Iterable<AppPermission> permissions) {
    return permissions.every(canPermission);
  }

  /// Checks whether the role is allowed to perform ANY permission.
  bool canAny(Iterable<AppPermission> permissions) {
    return permissions.any(canPermission);
  }
}
