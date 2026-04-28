import 'package:workorder_company_app/core/authorization/feature/service_request_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class RouteServiceRequestPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.serviceRequestCreate: ServiceRequestPermission.create,
    AppRoutes.serviceRequestInbox: ServiceRequestPermission.view,
    AppRoutes.serviceRequestSent: ServiceRequestPermission.view,
    AppRoutes.serviceRequestReview: ServiceRequestPermission.update,
  };
}
