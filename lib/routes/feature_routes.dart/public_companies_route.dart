import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/company/presentation/pages/public_companies_list_page.dart';
import 'package:workorder_company_app/features/company/presentation/pages/public_company_detail_page.dart';
import 'package:workorder_company_app/features/submissions/presentation/pages/fill_form_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final publicCompaniesRouter = [
  GoRoute(
    path: AppRoutes.publicCompanies,
    builder: (_, __) => PublicCompaniesListPage(),
  ),
  GoRoute(
    path: AppRoutes.publicCompaniesDetail,
    builder: (_, state) {
      final id = state.pathParameters['id']!;
      return PublicCompanyDetailPage(
        companyId: id,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.publicServiceDetail,
    builder: (_, state) {
      final id = state.pathParameters['id']!;
      return FillFormPage(
        serviceId: id,
      );
    },
  )
];
