import '../enums/app_feature.dart';
import '../enums/permission_action.dart';
/// Represents a single permission in the application.
///
/// An [AppPermission] is defined by:
/// - A specific application feature ([AppFeature])
/// - A specific action that can be performed on that feature ([PermissionAction])
///
/// This class acts as a **value object** and is intentionally immutable.
///
/// Example permissions:
/// - View work orders
/// - Create work orders
/// - Approve work orders
///
/// Example:
/// ```dart
/// AppPermission(
///   AppFeature.workOrder,
///   PermissionAction.approve,
/// )
/// ```
///
/// Equality (`==`) and `hashCode` are overridden so that
/// permissions can be safely stored and compared inside
/// collections such as [Set] or used as map keys.
///
/// This design enables:
/// - Fast permission lookup using `Set.contains(...)`
/// - Clear separation between features and actions
/// - Scalable permission management as the application grows
class AppPermission {
  final AppFeature feature;
  final PermissionAction action;

  const AppPermission(this.feature, this.action);

  @override
  bool operator ==(Object other) =>
      other is AppPermission &&
      other.feature == feature &&
      other.action == action;

  @override
  int get hashCode => Object.hash(feature, action);
}
