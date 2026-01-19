
import 'package:workorder_company_app/core/authorization/feature/employee_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteWorkorderPermissions {
  static final Map<String, AppPermission> route= {
    AppRoutes.employee: EmployeePermission.view,
    AppRoutes.employeeDetail: EmployeePermission.view,
    AppRoutes.employeeInvite: EmployeePermission.create,
  };
}