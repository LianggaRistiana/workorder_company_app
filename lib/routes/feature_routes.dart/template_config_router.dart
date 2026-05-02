import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/template_config/presentation/pages/company_types_page.dart';
import 'package:workorder_company_app/features/template_config/presentation/pages/form_preview_page.dart';
import 'package:workorder_company_app/features/template_config/presentation/pages/service_templates_page.dart';
import 'package:workorder_company_app/features/template_config/presentation/pages/service_templates_preview_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/guards/route_guard.dart';

// TODO : add permission to access this page
final templateConfigRouters = [
  GoRoute(
    path: AppRoutes.templateCompanyType,
    builder: (_, __) => CompanyTypesPage(),
  ),
  GoRoute(
    path: AppRoutes.templateFormPreview,
    redirect: requireExtra<FormEntity>(),
    builder: (_, state) => FormPreviewPage(form: state.extra as FormEntity),
  ),
  GoRoute(
    path: AppRoutes.templateService,
    redirect: requireParam('id'),
    builder: (_, state) => ServiceTemplatesPage(
      companyTypeId: state.pathParameters['id']!,
    ),
  ),
  GoRoute(
    path: AppRoutes.templateServicePreview,
    redirect: requireParam('id'),
    builder: (_, state) => ServiceTemplatesPreviewPage(
      servicePreviewId: state.pathParameters['id']!,
    ),
  ),
];
