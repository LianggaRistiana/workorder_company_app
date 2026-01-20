import 'package:workorder_company_app/core/authorization/feature/csr_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteCsrPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.serviceRequest: CsrPermission.view,
    AppRoutes.serviceRequestDetail: CsrPermission.view,
  };
}
