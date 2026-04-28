import 'package:workorder_company_app/core/authorization/feature/work_report_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteWorkReportPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.workReport: WorkReportPermissions.view,
    AppRoutes.workReportSubmission: WorkReportPermissions.fill,
  };
}
