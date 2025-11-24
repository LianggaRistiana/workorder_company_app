import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_detail_cubit.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/pages/csr_detail_page.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/pages/csr_page.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/manager_company_homepage.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/manager_company_layout.dart';

final managerRouter = [
  ShellRoute(
      builder: (context, state, child) => ManagerCompanyLayout(child: child),
      routes: [
        GoRoute(
          path: '/manager',
          redirect: (_, __) => AppRoutes.home,
        ),
        GoRoute(
          path: AppRoutes.managerHome,
          builder: (_, __) => const ManagerCompanyHomepage(),
        ),
        GoRoute(
          path: AppRoutes.managerCsr,
          builder: (_, __) {
            return BlocProvider(
              create: (_) => sl<InternalCsrBloc>(),
              child: CsrPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.managerProfile,
          builder: (_, __) => const ProfilePage(),
        ),
        GoRoute(
          path: "${AppRoutes.managerCsr}/:id",
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            return BlocProvider(
              create: (_) => sl<InternalCsrDetailCubit>(),
              child: CsrDetailPage(csrId: id),
            );
          },
        ),
      ])
];
