import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines all permission configurations related to the Employee feature.
///
/// ---------------------------------------------------------------------------
/// EMPLOYEE PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for
/// the `employee` feature.
///
/// The Employee feature manages personnel records within a company,
/// including employee lifecycle operations such as
/// modification, and removal.
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows viewing employee information and profiles.
///
/// • [update]
///   Allows modifying employee information.
///
/// • [delete]
///   Allows removing an employee from the company.
///
/// ---------------------------------------------------------------------------
/// PERMISSION GROUPS
/// ---------------------------------------------------------------------------
///
/// • [all]
///   Grants full access to all employee-related actions:
///   - view
///   - update
///   - delete
///
///   Typically assigned to high-privilege roles such as Owner
///   or Human Resource managers.
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - Employee permissions are resource-oriented.
/// - This class defines capability exposure only.
/// - Authorization checks must be enforced at the domain/application layer.
/// - UI-level visibility control alone is not sufficient for security.
///
class EmployeePermission {
  static const view = AppPermission(AppFeature.employee, PermissionAction.view);

  static const update =
      AppPermission(AppFeature.employee, PermissionAction.update);
  static const delete =
      AppPermission(AppFeature.employee, PermissionAction.delete);

  static final Set<AppPermission> all = {
    view,
    update,
    delete,
  };
}
