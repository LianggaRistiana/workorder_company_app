import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines all permission configurations related to the Company feature.
///
/// ---------------------------------------------------------------------------
/// COMPANY PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for
/// the `company` feature.
///
/// The Company feature represents high-level company configuration and
/// organizational data management.
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows viewing company profile and related information.
///
/// • [update]
///   Allows modifying company data such as profile details,
///   configuration, or other editable attributes.
///
/// ---------------------------------------------------------------------------
/// PERMISSION GROUPS
/// ---------------------------------------------------------------------------
///
/// • [all]
///   Grants full access to all company-related actions:
///   - view
///   - update
///
///   Typically assigned to high-privilege roles (e.g. Owner).
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - Company permissions are resource-oriented (not actor-based).
/// - This class defines capability exposure only.
/// - Authorization enforcement must be handled in the
///   domain/application layer.
/// - UI-level checks alone are not sufficient for secure access control.
///
class CompanyPermission {
  static const view = AppPermission(AppFeature.company, PermissionAction.view);
  static const update =
      AppPermission(AppFeature.company, PermissionAction.update);

  static final Set<AppPermission> all = {
    view,
    update,
  };
}
