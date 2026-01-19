import 'package:workorder_company_app/core/authorization/feature/form_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteFormPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.forms: FormPermission.view,
    AppRoutes.formsDetail: FormPermission.view,
    AppRoutes.formsCreate: FormPermission.create,
    AppRoutes.formsUpdate: FormPermission.update,
  };
}
