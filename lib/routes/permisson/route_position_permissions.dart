import 'package:workorder_company_app/core/authorization/feature/service_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RoutePositionPermissions {
  static final Map<String, AppPermission> route= {
    AppRoutes.services: ServicePermission.view,
    AppRoutes.servicesDetail: ServicePermission.view,
    AppRoutes.servicesCreate: ServicePermission.create,
    AppRoutes.servicesUpdate: ServicePermission.update,
  };
}