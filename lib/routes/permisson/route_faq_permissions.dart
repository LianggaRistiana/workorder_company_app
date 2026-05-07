import 'package:workorder_company_app/core/authorization/feature/faq_config_permission.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class RouteFaqPermissions {
  static final Map<String, AppPermission> route = {
    AppRoutes.companyFaqConfig: FaqConfigPermission.view,
    AppRoutes.addPdfFaqDoc: FaqConfigPermission.createDocs,
    AppRoutes.addTextFaqDoc: FaqConfigPermission.createDocs,
  };
}
