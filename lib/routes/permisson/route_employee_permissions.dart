
import 'package:workorder_company_app/core/authorization/feature/positions_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteEmployeePermissions {
  static final Map<String, AppPermission> route= {
    AppRoutes.positions: PositionsPermission.view,
    AppRoutes.positionsDetail: PositionsPermission.view,
    AppRoutes.positionsCreate: PositionsPermission.create,
    AppRoutes.positionsUpdate: PositionsPermission.update,
  };
}