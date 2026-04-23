import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';

/// Defines all permission configurations related to the Work Order feature.
///
/// ---------------------------------------------------------------------------
/// WORK ORDER PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for the
/// `workOrder` feature.
///
/// The Work Order lifecycle in this system follows a responsibility-driven flow:
///
///   Create → Send → Assignment Response → Start → Fill → Complete/Fail/Cancel
///
/// Important:
/// In this context, `approve` and `reject` do NOT represent managerial approval.
/// They represent employee assignment response:
///
/// - approve  → employee accepts the work assignment
/// - reject   → employee declines the work assignment
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows viewing work order details.
///
/// • [create]
///   Allows creating a new work order.
///
/// • [send]
///   Allows sending a drafted work order for assignment.
///
/// • [approve]
///   Allows an assigned employee to accept the work order assignment.
///
/// • [reject]
///   Allows an assigned employee to decline the work order assignment.
///
/// • [start]
///   Allows starting an accepted work order.
///
/// • [fill]
///   Allows updating operational data during execution.
///
/// • [complete]
///   Allows marking the work order as successfully completed.
///
/// • [fail]
///   Allows marking the work order as failed.
///
/// • [cancel]
///   Allows cancelling a work order.
///
/// ---------------------------------------------------------------------------
/// PERMISSION GROUPS
/// ---------------------------------------------------------------------------
///
/// • [all]
///   Grants full access to all work order actions.
///
/// • [creator]
///   Intended for users who initiate and manage work orders:
///   - view
///   - create
///   - send
///   - cancel
///   - complete
///   - fail
///   - fill
///
/// • [worker]
///   Intended for employees assigned to execute work orders:
///   - view
///   - approve  (accept assignment)
///   - reject   (decline assignment)
///   - start
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - `approve` and `reject` represent assignment availability, not managerial approval.
/// - Permission grouping is responsibility-based, not hierarchical.
/// - Enforcement must be handled in the authorization layer.
/// - UI visibility alone is not sufficient for access control.
///
class WorkOrderPermissions {
  static const view =
      AppPermission(AppFeature.workOrder, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.workOrder, PermissionAction.create);
  static const send =
      AppPermission(AppFeature.workOrder, PermissionAction.send);
  static const approve =
      AppPermission(AppFeature.workOrder, PermissionAction.approve);
  static const reject =
      AppPermission(AppFeature.workOrder, PermissionAction.reject);
  static const start =
      AppPermission(AppFeature.workOrder, PermissionAction.start);
  static const cancel =
      AppPermission(AppFeature.workOrder, PermissionAction.cancel);
  static const fill =
      AppPermission(AppFeature.workOrder, PermissionAction.fill);
  static const complete =
      AppPermission(AppFeature.workOrder, PermissionAction.complete);
  static const fail =
      AppPermission(AppFeature.workOrder, PermissionAction.fail);

  static final Set<AppPermission> all = {
    view,
    create,
    approve,
    reject,
    start,
    cancel,
    fill,
    complete,
    fail,
    send
  };

  static final Set<AppPermission> creator = {
    view,
    create,
    cancel,
    complete,
    fill,
    fail,
    send
  };

  static final Set<AppPermission> worker = {
    view,
    approve,
    start,
    reject,
  };
}
