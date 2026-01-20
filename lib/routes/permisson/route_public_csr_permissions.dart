import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/core/authorization/feature/csr_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class RoutePublicCsrPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.serviceRequestClientSide: CsrPermission.view,
    AppRoutes.serviceRequestDetailClientSide: CsrPermission.view,
  };
}
