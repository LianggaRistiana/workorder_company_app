import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/shared/layout/navigation/app_navigation_drawer.dart';
import 'package:workorder_company_app/shared/page/loading_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/navigation/app_navigantion_bar.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final path = GoRouterState.of(context).uri.path;

    if (authState is! Authenticated) {
      return LoadingPage();
    }

    final role = authState.user.role;
    final bool isMainPage = _roleMainPages[role]?.contains(path) ?? false;

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: isMainPage && isLandscape
          ? AppBar()
          : null, // TODO[OBSERVE] : observe this
      drawer:
          isMainPage && isLandscape ? AppNavigationDrawer(role: role) : null,
      bottomNavigationBar:
          isMainPage && !isLandscape ? AppNavigationBar(role: role) : null,
      body: child,
    );
  }
}

final Map<UserRole, List<String>> _roleMainPages = {
  UserRole.ownerCompany: [AppRoutes.home, AppRoutes.companyManageMenu],
  UserRole.managerCompany: [
    AppRoutes.home,
    AppRoutes.serviceRequestInbox,
    AppRoutes.workorders
  ],
  UserRole.staffCompany: [AppRoutes.home, AppRoutes.workorders],
  UserRole.staffUnassigned: [AppRoutes.home, AppRoutes.invitationsPending],
  UserRole.client: [AppRoutes.home, AppRoutes.publicCompanies],
};
