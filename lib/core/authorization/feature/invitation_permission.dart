import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

/// Defines all permission configurations related to the Invitation feature.
///
/// ---------------------------------------------------------------------------
/// INVITATION PERMISSION MODEL
/// ---------------------------------------------------------------------------
///
/// This class encapsulates all available [AppPermission] instances for
/// handling company invitations.
///
/// Invitations represent the mechanism for onboarding users into a company environtment.
/// The permission model is actor-based and separated into two perspectives:
///
/// - Sender   → the user who sends the invitation
/// - Receiver → the user who receives the invitation
///
/// Each actor interacts with a different feature scope:
/// - [AppFeature.senderInvitation]
/// - [AppFeature.receiverInvitation]
///
/// ---------------------------------------------------------------------------
/// SENDER PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [senderView]
///   Allows viewing invitations that were sent.
///
/// • [create]
///   Allows creating (sending) a new invitation.
///
/// • [cancel]
///   Allows cancelling a previously sent invitation.
///
/// • [sender]
///   Grouped permissions for invitation senders:
///   - view sent invitations
///   - create invitations
///   - cancel invitations
///
/// ---------------------------------------------------------------------------
/// RECEIVER PERMISSIONS
/// ---------------------------------------------------------------------------
///
/// • [receiverView]
///   Allows viewing received invitations.
///
/// • [approve]
///   Allows accepting an invitation.
///
/// • [reject]
///   Allows declining an invitation.
///
/// • [receiver]
///   Grouped permissions for invitation receivers:
///   - view received invitations
///   - approve (accept)
///   - reject (decline)
///
/// ---------------------------------------------------------------------------
/// DESIGN NOTES
/// ---------------------------------------------------------------------------
///
/// - This permission structure is actor-oriented rather than resource-oriented.
/// - Sender and Receiver operate on different feature scopes to ensure
///   clear separation of access control.
/// - This class defines capability exposure only.
/// - Actual authorization enforcement must be handled in the
///   domain/application layer.
/// - UI visibility checks alone are not sufficient for security.
///
class InvitationPermission {
  static const senderView =
      AppPermission(AppFeature.senderInvitation, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.senderInvitation, PermissionAction.create);
  static const cancel =
      AppPermission(AppFeature.senderInvitation, PermissionAction.cancel);

  static const receiverView =
      AppPermission(AppFeature.receiverInvitation, PermissionAction.view);
  static const reject =
      AppPermission(AppFeature.receiverInvitation, PermissionAction.reject);
  static const approve =
      AppPermission(AppFeature.receiverInvitation, PermissionAction.approve);

  static final Set<AppPermission> sender = {senderView, create, cancel};

  static final Set<AppPermission> receiver = {receiverView, reject, approve};
}
