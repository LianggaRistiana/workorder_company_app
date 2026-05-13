import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/system_integration/presentation/pages/account_pairing_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final systemIntegrationRouter = [
  GoRoute(
    path: AppRoutes.pairAccount,
    builder: (_, state) {
      final id = state.pathParameters["id"]!;

      return AccountPairingPage(
        companyId: id,
      );
    },
  ),
];
