import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/company/presentation/pages/companies_page.dart';
import 'package:workorder_company_app/features/company/presentation/pages/company_detail_page.dart';
import 'package:workorder_company_app/features/submissions/presentation/pages/fill_form_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/public_companies_wrapper.dart';

final publicCompaniesRouter = [
  ShellRoute(
      builder: (context, state, child) => PublicCompaniesWrapper(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.publicCompanies,
          builder: (_, __) => CompaniesPage(),
        ),
        GoRoute(
          path: AppRoutes.publicCompaniesDetail,
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            return CompanyDetailPage(
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
      ])
];
