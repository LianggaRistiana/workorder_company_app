import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class CsrPermission {
  static const view =
      AppPermission(AppFeature.clientServiceRequest, PermissionAction.view);
  static const action =
      AppPermission(AppFeature.clientServiceRequest, PermissionAction.action);

  static final Set<AppPermission> all = {
    view,
    action
  };
}