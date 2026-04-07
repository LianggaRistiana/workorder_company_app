import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class FormPermission {
  static const view = AppPermission(AppFeature.form, PermissionAction.view);
  static const create = AppPermission(AppFeature.form, PermissionAction.create);
  static const update = AppPermission(AppFeature.form, PermissionAction.update);
  static const delete = AppPermission(AppFeature.form, PermissionAction.delete);

  static final Set<AppPermission> all = {view, create, update, delete};
}
