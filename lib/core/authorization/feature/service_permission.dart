import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines all permission configurations related to the Service feature.
///
/// ---------------------------------------------------------------------------
/// SERVICE PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for
/// the `service` feature.
///
/// A Service represents a configurable offering provided by the company.
/// Services typically define operational workflows and may be associated
/// with Forms, Service Requests, and Work Orders.
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows viewing service definitions and configurations.
///
/// • [create]
///   Allows creating a new service.
///
/// • [update]
///   Allows modifying an existing service.
///
/// • [delete]
///   Allows removing a service.
///
/// ---------------------------------------------------------------------------
/// PERMISSION GROUPS
/// ---------------------------------------------------------------------------
///
/// • [all]
///   Grants full access to all service-related actions:
///   - view
///   - create
///   - update
///   - delete
///
///   Typically assigned to high-privilege roles such as Owner
///   or Service Managers.
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - Service permissions are resource-oriented.
/// - Deleting a service may require domain validation
///   (e.g., preventing deletion if active Work Orders exist).
/// - This class defines capability exposure only.
/// - Authorization enforcement must be handled in the
///   domain/application layer.
///
class ServicePermission {
  static const view = AppPermission(AppFeature.service, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.service, PermissionAction.create);
  static const update =
      AppPermission(AppFeature.service, PermissionAction.update);
  static const delete =
      AppPermission(AppFeature.service, PermissionAction.delete);

  static final Set<AppPermission> all = {view, create, update, delete};
}
