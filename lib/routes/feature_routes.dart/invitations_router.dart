import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/invitations/presentation/pages/invitations_history_page.dart';
import 'package:workorder_company_app/features/invitations/presentation/pages/receiver_invitations_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final invitationsRouter = [
  GoRoute(
    path: AppRoutes.invitationsHistory,
    builder: (_, __) => const InvitationsHistoryPage(),
  ),
  GoRoute(
    path: AppRoutes.invitationsPending,
    builder: (_, __) => const ReceiverInvitationsPage(),
  ),
];
