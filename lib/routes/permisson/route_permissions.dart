import 'package:workorder_company_app/core/authorization/feature/workorder_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';


class RoutePermissions {
  static final Map<String, AppPermission> map = {
    // Work Order Route
    AppRoutes.workorders: WorkOrderPermissions.view,
    AppRoutes.workordersDetail: WorkOrderPermissions.view,
    AppRoutes.workordersAssignStaff: WorkOrderPermissions.assign,
    AppRoutes.workordersSubmission: WorkOrderPermissions.update,
    // AppRoutes.workOrderAssign: WorkOrderPermissions.assign,
  };
}
