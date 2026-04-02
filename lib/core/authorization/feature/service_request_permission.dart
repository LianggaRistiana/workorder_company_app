import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class ServiceRequestPermission {
  static const view =
      AppPermission(AppFeature.serviceRequest, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.serviceRequest, PermissionAction.create);
  static const update =
      AppPermission(AppFeature.serviceRequest, PermissionAction.update);
  static const approve =
      AppPermission(AppFeature.serviceRequest, PermissionAction.approve);
  static const reject =
      AppPermission(AppFeature.serviceRequest, PermissionAction.reject);
  static const cancel =
      AppPermission(AppFeature.serviceRequest, PermissionAction.cancel);

  static final Set<AppPermission> receiver = {
    view,
    approve,
    reject,
  };

  static final Set<AppPermission> requester = {
    view,
    create,
    update,
    cancel,
  };
}
