import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
// TODO : explicit permision rather than update
class WorkOrderPermissions {
  static const view =
      AppPermission(AppFeature.workOrder, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.workOrder, PermissionAction.create);
  static const update =
      AppPermission(AppFeature.workOrder, PermissionAction.update);

  static final Set<AppPermission> all = {
    view,
    create,
    update,
  };
}
