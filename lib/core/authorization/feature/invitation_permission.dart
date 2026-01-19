import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class InvitationPermission {
  static const view =
      AppPermission(AppFeature.company, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.company, PermissionAction.create);
  static const cancel =
      AppPermission(AppFeature.company, PermissionAction.cancel);
  static const reject =
      AppPermission(AppFeature.company, PermissionAction.reject);
  static const approve =
      AppPermission(AppFeature.company, PermissionAction.approve);

  static final Set<AppPermission> admin = {
    view,
    create,
    cancel
  };
  static final Set<AppPermission> unassigned = {
    view,
    reject,
    approve
  };
}