import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class CsrPermission {
  static const view =
      AppPermission(AppFeature.clientServiceRequest, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.clientServiceRequest, PermissionAction.create);
  static const update =
      AppPermission(AppFeature.clientServiceRequest, PermissionAction.update);
  static const cancel =
      AppPermission(AppFeature.clientServiceRequest, PermissionAction.cancel);
  static const reject =
      AppPermission(AppFeature.clientServiceRequest, PermissionAction.reject);
  static const approve =
      AppPermission(AppFeature.clientServiceRequest, PermissionAction.approve);

  static final Set<AppPermission> client = {
    view,
    create,
    cancel
  };
  static final Set<AppPermission> admin = {
    view,
    reject,
    approve
  };
}