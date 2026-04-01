import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/presentation/pages/internal_company_edit_page.dart';
import 'package:workorder_company_app/features/company/presentation/pages/internal_company_profile_page.dart';
import 'package:workorder_company_app/features/company/presentation/pages/Internal_company_manage_menu_page.dart.dart';
import 'package:workorder_company_app/features/faq/presentation/pages/company_faq_config_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final companyRouter = [
  GoRoute(
    path: AppRoutes.companyManageMenu,
    builder: (_, __) => InternalCompanyManageMenuPage(),
  ),
  GoRoute(
    path: AppRoutes.company,
    builder: (_, __) => InternalCompanyProfilePage(),
  ),
  GoRoute(
    path: AppRoutes.companyUpdate,
    builder: (_, state) {
      return InternalCompanyEditPage(
        company: state.extra as CompanyEntity,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.companyFaqConfig,
    builder: (_, __) => CompanyFaqConfigPage(),
  ),
];
