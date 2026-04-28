import 'package:workorder_company_app/core/authorization/feature/work_order_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteWorkOrderPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.workOrders: WorkOrderPermissions.view,
    AppRoutes.workOrdersAssignStaff: WorkOrderPermissions.fill,
    AppRoutes.workOrdersSubmission: WorkOrderPermissions.fill,
    AppRoutes.workOrdersDetail: WorkOrderPermissions.view,
  };
}
