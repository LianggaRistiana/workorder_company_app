import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/permisson/route_company_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_employee_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_faq_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_form_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_invitation_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_memberships_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_position_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_quick_config_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_service_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_service_request_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_work_order_permissions.dart';
import 'package:workorder_company_app/routes/permisson/route_work_report_permissions.dart';

class RoutePermissions {
  static final Map<String, AppPermission> map = {
    // Company Fetaure
    ...RouteCompanyPermissions.route,
    ...RouteMembershipsPermissions.route,
    ...RouteFaqPermissions.route,
    ...RouteQuickConfigPermissions.route,

    // Human Resource Feature
    ...RoutePositionPermissions.route,
    ...RouteEmployeePermissions.route,
    ...RouteInvitationPermissions.route,

    // Service Feature
    ...RouteFormPermissions.route,
    ...RouteServicePermissions.route,

    // Work Order Trilogy
    ...RouteServiceRequestPermissions.route,
    ...RouteWorkOrderPermissions.route,
    ...RouteWorkReportPermissions.route,
  };
}
