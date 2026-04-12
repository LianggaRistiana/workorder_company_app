import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/permisson/route_company_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_employee_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_form_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_invitation_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_memberships_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_position_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_service_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_work_order_permissions.dart';

class RoutePermissions {
  static final Map<String, AppPermission> map = {
    ...RouteEmployeePermissions.route,
    ...RouteFormPermissions.route,
    ...RouteInvitationPermissions.route,
    ...RoutePositionPermissions.route,
    ...RouteServicePermissions.route,
    ...RouteWorkOrderPermissions.route,
    ...RouteCompanyPermissions.route,
    ...RouteMembershipsPermissions.route,
  };
}
