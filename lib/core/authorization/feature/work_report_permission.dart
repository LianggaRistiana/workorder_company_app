import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines all permission configurations related to the Work Report feature.
///
/// ---------------------------------------------------------------------------
/// WORK REPORT PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for the
/// `workReport` feature. Each permission is defined as a combination of:
///
/// - [AppFeature.workReport]
/// - A specific [PermissionAction]
///
/// The permission structure follows a role-responsibility approach, where
/// permissions can be grouped based on operational responsibilities such as:
///
/// - Worker (operational staff)
/// - Reviewer (manager / approver)
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows reading or viewing a work report.
///
/// • [fill]
///   Allows filling or editing report content before submission.
///
/// • [send]
///   Allows submitting a completed report for review.
///
/// • [approve]
///   Allows approving a submitted report.
///
/// • [reject]
///   Allows rejecting a submitted report.
///
/// ---------------------------------------------------------------------------
/// PERMISSION GROUPS
/// ---------------------------------------------------------------------------
///
/// • [all]
///   Grants full access to all available work report actions.
///   Typically assigned to high-privilege roles (e.g. Owner).
///
/// • [worker]
///   Grants operational-level permissions:
///   - view
///   - fill
///   - send
///
///   Intended for staff responsible for completing and submitting reports.
///
/// • [reviewer]
///   Grants oversight-level permissions:
///   - view
///   - approve
///   - reject
///
///   Intended for managers responsible for validation.
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - Permissions are grouped using `Set<AppPermission>` to prevent duplication.
/// - This class only defines capability exposure.
/// - Enforcement must still be performed at the authorization layer.
/// - UI-level checks alone are not sufficient for security.
/// 
class WorkReportPermissions {
  static const view =
      AppPermission(AppFeature.workReport, PermissionAction.view);
  static const fill =
      AppPermission(AppFeature.workReport, PermissionAction.fill);
  static const approve =
      AppPermission(AppFeature.workReport, PermissionAction.approve);
  static const reject =
      AppPermission(AppFeature.workReport, PermissionAction.reject);
  static const send =
      AppPermission(AppFeature.workReport, PermissionAction.send);

  static final Set<AppPermission> all = {
    view,
    fill,
    approve,
    reject,
    send,
  };

  static final Set<AppPermission> reviewer = {
    view,
    approve,
    reject,
  };

  static final Set<AppPermission> worker = {
    view,
    send,
    fill,
  };
}
