import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/memberships/presentation/pages/claim_membership_code_page.dart';
import 'package:workorder_company_app/features/memberships/presentation/pages/member_list_page.dart';
import 'package:workorder_company_app/features/memberships/presentation/pages/membership_codes_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final membershipsRouter = [
  GoRoute(
      path: AppRoutes.memberships, builder: (_, __) => const MemberListPage()),
  GoRoute(
      path: AppRoutes.membershipsCodes,
      builder: (_, __) => const MembershipCodesListPage()),
  GoRoute(
      path: AppRoutes.membershipsClaim,
      builder: (_, __) => const ClaimMembershipCodePage()),
];
