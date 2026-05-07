import 'package:workorder_company_app/core/authorization/feature/quick_config_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteQuickConfigPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.templateCompanyType: QuickConfigPermission.view,
    AppRoutes.templateService: QuickConfigPermission.view,
    AppRoutes.templateServicePreview: QuickConfigPermission.view,
    AppRoutes.templateFormPreview: QuickConfigPermission.view,
  };
}
