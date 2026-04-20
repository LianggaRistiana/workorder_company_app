import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines all permission configurations related to the Service Request feature.
///
/// ---------------------------------------------------------------------------
/// SERVICE REQUEST PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for the
/// `serviceRequest` feature.
///
/// A Service Request represents the initial demand or submission made before
/// a Work Order is created. It acts as the entry point of the operational flow.
///
/// Typical lifecycle:
///
///   Create → Review (Approve/Reject) → Converted to Work Order / Cancelled
///
/// Permissions are grouped based on actor responsibility:
/// - Requester (the one who submits the request)
/// - Receiver  (the one who reviews the request)
///
/// ---------------------------------------------------------------------------
/// INDIVIDUAL PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [view]
///   Allows viewing service request details.
///
/// • [create]
///   Allows creating a new service request.
///
/// • [update]
///   Allows modifying a pending service request.
///
/// • [approve]
///   Allows approving a submitted service request.
///
/// • [reject]
///   Allows rejecting a submitted service request.
///
/// • [cancel]
///   Allows cancelling a previously created service request.
///
/// ---------------------------------------------------------------------------
/// PERMISSION GROUPS
/// ---------------------------------------------------------------------------
///
/// • [requester]
///   Intended for users who initiate service requests:
///   - view
///   - create
///   - update
///   - cancel
///
/// • [receiver]
///   Intended for users responsible for reviewing incoming requests:
///   - view
///   - approve
///   - reject
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - `approve` and `reject` here represent review decisions on submitted
///   service requests.
/// - Permission grouping is actor-based (requester vs receiver).
/// - This class defines capability exposure only.
/// - Enforcement must be performed in the authorization layer.
/// - UI-level checks alone are not sufficient for secure access control.
///
class ServiceRequestPermission {
  static const view =
      AppPermission(AppFeature.serviceRequest, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.serviceRequest, PermissionAction.create);
  static const update =
      AppPermission(AppFeature.serviceRequest, PermissionAction.update);
  static const approve =
      AppPermission(AppFeature.serviceRequest, PermissionAction.approve);
  static const reject =
      AppPermission(AppFeature.serviceRequest, PermissionAction.reject);
  static const cancel =
      AppPermission(AppFeature.serviceRequest, PermissionAction.cancel);

  static final Set<AppPermission> receiver = {
    view,
    approve,
    reject,
  };

  static final Set<AppPermission> requester = {
    view,
    create,
    update,
    cancel,
  };
}
