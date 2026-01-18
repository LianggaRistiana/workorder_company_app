import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class ServicePermission {
  static const view =
      AppPermission(AppFeature.service, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.service, PermissionAction.create);
  static const update =
      AppPermission(AppFeature.service, PermissionAction.update);
  static const delete =
      AppPermission(AppFeature.service, PermissionAction.delete);

  static final Set<AppPermission> all = {
    view,
    create,
    update,
    delete
  };
}