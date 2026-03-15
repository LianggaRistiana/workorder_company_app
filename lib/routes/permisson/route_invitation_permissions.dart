import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';


// TODO : define sender and receiver permissions
class RouteInvitationPermissions {
  static final Map<String, AppPermission> route= {
    AppRoutes.employeeInvite: InvitationPermission.create,
    AppRoutes.invitationsHistory: InvitationPermission.adminView
  };
}