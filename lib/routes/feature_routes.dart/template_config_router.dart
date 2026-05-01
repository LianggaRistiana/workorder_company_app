import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/template_config/presentation/pages/company_types_page.dart';
import 'package:workorder_company_app/features/template_config/presentation/pages/service_templates_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/guards/route_guard.dart';

// TODO : add permission to access this page
final templateConfigRouters = [
  GoRoute(
    path: AppRoutes.templateCompanyType,
    builder: (_, __) => CompanyTypesPage(),
  ),
  GoRoute(
    path: AppRoutes.templateService,
    redirect: requireParam('id'),
    builder: (_, state) => ServiceTemplatesPage(
      companyTypeId: state.pathParameters['id']!,
    ),
  ),
];
