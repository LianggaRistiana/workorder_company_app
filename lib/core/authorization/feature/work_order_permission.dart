import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';

class WorkOrderPermissions {
  static const view =
      AppPermission(AppFeature.workOrder, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.workOrder, PermissionAction.create);
  static const approve =
      AppPermission(AppFeature.workOrder, PermissionAction.approve);
  static const reject =
      AppPermission(AppFeature.workOrder, PermissionAction.reject);
  static const start =
      AppPermission(AppFeature.workOrder, PermissionAction.start);
  static const cancel =
      AppPermission(AppFeature.workOrder, PermissionAction.cancel);
  static const fill =
      AppPermission(AppFeature.workOrder, PermissionAction.fill);
  static const complete =
      AppPermission(AppFeature.workOrder, PermissionAction.complete);
  static const fail =
      AppPermission(AppFeature.workOrder, PermissionAction.fail);

  static final Set<AppPermission> all = {
    view,
    create,
    approve,
    reject,
    start,
    cancel,
    fill,
    complete,
    fail
  };

  static final Set<AppPermission> creator = {
    view,
    create,
    cancel,
    complete,
    fail
  };

  static final Set<AppPermission> worker = {
    view,
    approve,
    start,
    reject,
  };
}
