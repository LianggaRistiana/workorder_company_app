import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/pages/claim_invitation_code_page.dart';
import 'package:workorder_company_app/features/invitation_codes/presentation/pages/invitation_code_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final invitationCodesRouter = [
  GoRoute(
    path: AppRoutes.invitationCodeList,
    builder: (_, __) => const InvitationCodeListPage(),
  ),
  GoRoute(
    path: AppRoutes.claimInvitationCode,
    builder: (_, __) => const ClaimInvitationCodePage(),
  ),
];
