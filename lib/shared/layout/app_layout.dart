import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/features/splash/splash_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/navigation/app_navigantion_bar.dart';

// ===================== WIHT OUT ANIMATE ==============================
class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final path = GoRouterState.of(context).uri.path;

    if (authState is! Authenticated) {
      return SplashPage();
    }

    final role = authState.user.role;
    final bool isMainPage = _roleMainPages[role]?.contains(path) ?? false;

    return Scaffold(
      body: child,
      bottomNavigationBar: isMainPage ? AppNavigationBar(role: role) : null,
    );
  }
}

final Map<UserRole, List<String>> _roleMainPages = {
  UserRole.ownerCompany: [AppRoutes.home, AppRoutes.companyManageMenu],
  UserRole.managerCompany: [AppRoutes.home, AppRoutes.serviceRequest, AppRoutes.workorders],
  UserRole.staffCompany: [AppRoutes.home, AppRoutes.workorders],
  UserRole.staffUnassigned: [AppRoutes.home, AppRoutes.invitationsPending],
  UserRole.client: [AppRoutes.home, AppRoutes.publicCompanies],
};
