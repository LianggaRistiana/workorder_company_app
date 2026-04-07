import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class PositionsPermission {
  static const view =
      AppPermission(AppFeature.positions, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.positions, PermissionAction.create);
  static const update =
      AppPermission(AppFeature.positions, PermissionAction.update);
  static const delete =
      AppPermission(AppFeature.positions, PermissionAction.delete);

  static final Set<AppPermission> all = {view, create, update, delete};
}
