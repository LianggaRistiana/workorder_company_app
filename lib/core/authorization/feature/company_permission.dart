import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class CompanyPermission {
  static const view =
      AppPermission(AppFeature.company, PermissionAction.view);
  static const update =
      AppPermission(AppFeature.company, PermissionAction.update);

  static final Set<AppPermission> all = {
    view,
    update,
  };
}