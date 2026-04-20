import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines all permission configurations related to the Memberships feature.
///
/// ---------------------------------------------------------------------------
/// MEMBERSHIPS PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for
/// the membership system.
///
/// Memberships represent the relationship between a user and a company.
/// This feature also includes the mechanism for joining a company via
/// invitation or claim code.
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows viewing membership information within a company.
///
/// • [create]
///   Allows creating or assigning memberships (e.g., adding users to a company).
///
/// • [claim]
///   Allows claiming a membership using an invitation or claim code.
///
///   This permission uses the `claimCodeMembership` feature scope and is
///   intended for external or joining users.
///
/// ---------------------------------------------------------------------------
/// PERMISSION GROUPS
/// ---------------------------------------------------------------------------
///
/// • [provider]
///   Intended for users who manage or provide memberships within a company:
///   - view
///   - create
///
///   Typically assigned to Owner or administrative roles.
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - Memberships are part of company-user relationship management.
/// - Claiming a membership is treated as a separate feature scope
///   (`claimCodeMembership`) to isolate external onboarding logic.
/// - This class defines capability exposure only.
/// - Authorization enforcement must be handled in the
///   domain/application layer.
/// - UI-level checks alone are not sufficient for security.
///
class MembershipsPermission {
  static const view =
      AppPermission(AppFeature.memberships, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.memberships, PermissionAction.create);
  static const claim =
      AppPermission(AppFeature.claimCodeMembership, PermissionAction.create);

  static final Set<AppPermission> provider = {
    view,
    create,
  };
}
