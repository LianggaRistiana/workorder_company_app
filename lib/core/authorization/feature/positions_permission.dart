import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines all permission configurations related to the Positions feature.
///
/// ---------------------------------------------------------------------------
/// POSITIONS PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for
/// the `positions` feature.
///
/// The Positions feature manages organizational roles or job positions
/// within a company. These positions are typically used to structure
/// employee responsibilities and access levels.
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows viewing available positions within the company.
///
/// • [create]
///   Allows creating a new job position.
///
/// • [update]
///   Allows modifying an existing job position.
///
/// • [delete]
///   Allows removing a job position.
///
/// ---------------------------------------------------------------------------
/// PERMISSION GROUPS
/// ---------------------------------------------------------------------------
///
/// • [all]
///   Grants full access to all position-related actions:
///   - view
///   - create
///   - update
///   - delete
///
///   Typically assigned to high-privilege roles such as Owner
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - Positions permissions are resource-oriented.
/// - Deleting a position may require additional domain validation
///   (e.g., preventing deletion if employees are still assigned).
/// - This class defines capability exposure only.
/// - Authorization enforcement must be handled in the
///   domain/application layer.
///
class PositionsPermission {
  static const view =
      AppPermission(AppFeature.positions, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.positions, PermissionAction.create);
  static const update =
      AppPermission(AppFeature.positions, PermissionAction.update);
  static const delete =
      AppPermission(AppFeature.positions, PermissionAction.delete);

  static final Set<AppPermission> all = {view, create, update, delete};
}
