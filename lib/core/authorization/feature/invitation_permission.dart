import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class InvitationPermission {
  static const adminView =
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

  static final Set<AppPermission> sender = {adminView, create, cancel};

  static final Set<AppPermission> receiver = {receiverView, reject, approve};
}
