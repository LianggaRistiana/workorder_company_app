import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class MembershipsPermission {
  static const view =
      AppPermission(AppFeature.memberships, PermissionAction.view);
  static const create =
      AppPermission(AppFeature.memberships, PermissionAction.create);
  static const claim =
      AppPermission(AppFeature.claimCodeMembership, PermissionAction.create);

  static final Set<AppPermission> provider = {
    view,
    create,
  };
}
