import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/pages/public_csr_detail_page.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/pages/public_csr_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/public_csr_wrapper.dart';

final publicCsrRouter = [
  ShellRoute(
      builder: (context, state, child) => PublicCsrWrapper(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.serviceRequestClientSide,
          builder: (_, __) => const PublicCsrPage(),
        ),
        GoRoute(
          path: AppRoutes.serviceRequestDetailClientSide,
          builder: (_, state) {
            final id = state.pathParameters['id']!;
            return PublicCsrDetailPage(
              csrId: id,
            );
          },
        ),
      ])
];
