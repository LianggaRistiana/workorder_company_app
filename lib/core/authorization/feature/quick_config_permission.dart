import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class QuickConfigPermission {
  static const view =
      AppPermission(AppFeature.quickConfig, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.quickConfig, PermissionAction.create);

  static final Set<AppPermission> all = {
    view,
    create,
  };
}
