import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/invitations/presentation/pages/invitations_history_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final invitationsRoute = [
  GoRoute(
    path: AppRoutes.invitationsHistory,
    builder: (_, __) => const InvitationsHistoryPage(),
  ),
];
