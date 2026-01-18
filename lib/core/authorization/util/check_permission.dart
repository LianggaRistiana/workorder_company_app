import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/role_map/role_permission_map.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

/// Extension that provides reusable helpers for checking
/// authorization / permission based on [UserRole].
///
/// This extension is designed to:
/// - Centralize permission-checking logic
/// - Avoid permission logic scattered across UI, routing, or use cases
/// - Support scalability for multiple features and modules
/// - Keep the API simple and expressive
///
/// Example usage:
/// ```dart
/// if (user.role.canPermission(WorkOrderPermissions.assign)) {
///   // User is allowed to assign a work order
/// }
///
/// if (user.role.can(AppFeature.workOrder, PermissionAction.assign)) {
///   // User is allowed to perform assign action on work order feature
/// }
/// ```
extension PermissionCheck on UserRole {

  /// Checks whether the role owns a specific [AppPermission].
  ///
  /// This method verifies if the given [permission] exists
  /// in the permission set associated with the [UserRole].
  ///
  /// Recommended usage:
  /// - When permissions are defined as constants
  ///   (e.g. `WorkOrderPermissions.assign`)
  /// - Inside UI widgets such as `PermissionGate`
  /// - When you want to avoid recreating permission objects repeatedly
  ///
  /// Example:
  /// ```dart
  /// user.role.canPermission(WorkOrderPermissions.assign);
  /// ```
  bool canPermission(AppPermission permission) {
    return permissions.contains(permission);
  }

  /// Checks permission using a combination of [AppFeature]
  /// and [PermissionAction].
  ///
  /// This method is a convenience wrapper around [canPermission],
  /// allowing permission checks without importing feature-specific
  /// permission definitions.
  ///
  /// Recommended usage:
  /// - In domain layer or use cases
  /// - For dynamic permission checks
  /// - When feature and action are determined at runtime
  ///
  /// Internally, this method creates an [AppPermission]
  /// instance and delegates the validation to [canPermission].
  ///
  /// Example:
  /// ```dart
  /// user.role.can(
  ///   AppFeature.workOrder,
  ///   PermissionAction.assign,
  /// );
  /// ```
  bool can(AppFeature feature, PermissionAction action) {
    return canPermission(AppPermission(feature, action));
  }
}

