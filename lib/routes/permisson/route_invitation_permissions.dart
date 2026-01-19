import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteInvitationPermissions {
  static final Map<String, AppPermission> route= {
    AppRoutes.employeeInvite: InvitationPermission.create,
  };
}