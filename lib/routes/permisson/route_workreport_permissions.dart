import 'package:workorder_company_app/core/authorization/feature/workreport_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteWorkreportPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.workreports: WorkReportPermissions.view,
    AppRoutes.workreportsSubmit: WorkReportPermissions.update,
  };
}
