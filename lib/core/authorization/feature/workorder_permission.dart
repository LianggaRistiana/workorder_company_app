import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';

class WorkOrderPermissions {
  static const view =
      AppPermission(AppFeature.workOrder, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.workOrder, PermissionAction.create);
  static const assign =
      AppPermission(AppFeature.workOrder, PermissionAction.assign);
  static const approve =
      AppPermission(AppFeature.workOrder, PermissionAction.approve);
  static const update =
      AppPermission(AppFeature.workOrder, PermissionAction.update);
  static const cancel =
      AppPermission(AppFeature.workOrder, PermissionAction.cancel);

  static final Set<AppPermission> all = {
    view,
    create,
    assign,
    approve,
    update,
    cancel
  };
}
