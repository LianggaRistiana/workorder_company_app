import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

// TODO : add 'permission' to file name annd class name
class PublicCompanies {
  static const view =
      AppPermission(AppFeature.publicCompanies, PermissionAction.view);
}
