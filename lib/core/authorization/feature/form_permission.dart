import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines all permission configurations related to the Form feature.
///
/// ---------------------------------------------------------------------------
/// FORM PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for
/// the `form` feature.
///
/// Forms are typically used to define structured input templates
/// associated with services or operational workflows. They determine
/// what data must be collected during execution (e.g., Work Orders).
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows viewing form definitions.
///
/// • [create]
///   Allows creating a new form template.s
///
/// • [update]
///   Allows modifying an existing form template.
///
/// • [delete]
///   Allows removing a form template.
///
/// ---------------------------------------------------------------------------
/// PERMISSION GROUPS
/// ---------------------------------------------------------------------------
///
/// • [all]
///   Grants full access to all form-related actions:
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
/// - Form permissions are resource-oriented.
/// - Deleting a form may require domain validation
///   (e.g., preventing deletion if used by active services).
/// - This class defines capability exposure only.
/// - Authorization enforcement must be handled in the
///   domain/application layer.
///
class FormPermission {
  static const view = AppPermission(AppFeature.form, PermissionAction.view);
  static const create = AppPermission(AppFeature.form, PermissionAction.create);
  static const update = AppPermission(AppFeature.form, PermissionAction.update);
  static const delete = AppPermission(AppFeature.form, PermissionAction.delete);

  static final Set<AppPermission> all = {view, create, update, delete};
}
