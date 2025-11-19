import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_detail_cubit.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/pages/public_csr_detail_page.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/pages/public_csr_page.dart';
import 'package:workorder_company_app/features/company/presentation/pages/companies_page.dart';
import 'package:workorder_company_app/features/company/presentation/pages/company_detail_page.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/client_homepage.dart';
import 'package:workorder_company_app/features/submissions/presentation/pages/fill_form_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/client_layout.dart';

final clientRouter = [
  ShellRoute(
    builder: (context, state, child) => ClientLayout(child: child),
    routes: [
      GoRoute(
        path: '/client',
        redirect: (_, __) => AppRoutes.home,
      ),
      GoRoute(
        path: AppRoutes.clientHome,
        builder: (_, __) => const ClientHomepage(),
      ),
      GoRoute(
        path: AppRoutes.clientCompanyPortal,
        builder: (_, __) => const CompaniesPage(),
      ),
      GoRoute(
        path: AppRoutes.clientProfile,
        builder: (_, __) => const ProfilePage(),
      ),
      GoRoute(
        path: '${AppRoutes.clientCompanyPortal}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CompanyDetailPage(companyId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.clientServiceRequest,
        builder: (context, state) {
          return PublicCsrPage();
        },
      ),
    ],
  ),
  GoRoute(
    path: '${AppRoutes.clientServiceForms}/:id',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return FillFormPage(serviceId: id);
    },
  ),
  GoRoute(
    path: '${AppRoutes.clientServiceRequest}/:id',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return BlocProvider(
        create: (_) => sl<CsrDetailCubit>()..getCsrDetail(id),
        child: CsrDetailPage(csrId: id),
      );
    },
  )
];
