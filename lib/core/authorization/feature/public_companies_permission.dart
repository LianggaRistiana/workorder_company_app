import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines permission configuration for the Public Companies feature.
///
/// ---------------------------------------------------------------------------
/// PUBLIC COMPANIES PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates the available [AppPermission] for
/// the `publicCompanies` feature.
///
/// The Public Companies feature represents publicly accessible
/// company information that can be viewed by external users,
/// such as clients or non-member users.
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows viewing publicly available company information.
///
///   This permission is typically granted to:
///   - Clients
///   - External users
///   - Unauthenticated or limited-access roles (depending on system design)
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - This feature is intentionally limited to read-only access.
/// - No create/update/delete operations are exposed publicly.
/// - This class defines capability exposure only.
/// - Proper authorization enforcement must still be performed
///   in the application or domain layer.
///
class PublicCompaniesPermission {
  static const view =
      AppPermission(AppFeature.publicCompanies, PermissionAction.view);
}
