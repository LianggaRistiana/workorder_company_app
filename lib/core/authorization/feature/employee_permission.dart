import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class EmployeePermission {
  static const view =
      AppPermission(AppFeature.employee, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.employee, PermissionAction.create);
  static const update =
      AppPermission(AppFeature.employee, PermissionAction.update);
  static const delete =
      AppPermission(AppFeature.employee, PermissionAction.delete);

  static final Set<AppPermission> all = {
    view,
    create,
    update,
    delete
  };
}