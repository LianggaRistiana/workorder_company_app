import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class PublicCsrPermission {
  static const view =
      AppPermission(AppFeature.publicClientServiceRequest, PermissionAction.view);
      
  static const create =
      AppPermission(AppFeature.publicClientServiceRequest, PermissionAction.view);

  static const action =
      AppPermission(AppFeature.publicClientServiceRequest, PermissionAction.action);
}
