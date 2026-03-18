import 'package:workorder_company_app/core/authorization/feature/memberships_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteMembershipsPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.membershipsCodes: MembershipsPermission.view,
  };
}
