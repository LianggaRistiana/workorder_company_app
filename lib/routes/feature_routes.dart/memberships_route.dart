import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/memberships/presentation/pages/membership_codes_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final membershipsRoute = [
  GoRoute(
      path: AppRoutes.membershipsCodes,
      builder: (_, __) => const MembershipCodesListPage()),
];
