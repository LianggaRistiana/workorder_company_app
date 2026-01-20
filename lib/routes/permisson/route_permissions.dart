import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/permisson/route_csr_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_employee_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_form_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_invitation_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_position_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_public_csr_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_service_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_workorder_permissions.dart';

class RoutePermissions {
  static final Map<String, AppPermission> map = {
    ...RouteCsrPermissions.route,
    ...RouteEmployeePermissions.route,
    ...RouteFormPermissions.route,
    ...RouteInvitationPermissions.route,
    ...RoutePositionPermissions.route,
    ...RoutePublicCsrPermissions.route,
    
    ...RouteServicePermissions.route,
    ...RouteWorkorderPermissions.route,
  };
}
