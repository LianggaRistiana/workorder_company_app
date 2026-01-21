import 'package:workorder_company_app/core/authorization/feature/company_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteCompanyPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.company: CompanyPermission.view,
    AppRoutes.companyManageMenu: CompanyPermission.update, //TODO : change to view if each button in this page has permission gate
  };
}
