import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/shared/layout/authenticated_bloc_provider.dart';
import 'package:workorder_company_app/shared/layout/general_listener.dart';
import 'package:workorder_company_app/shared/layout/navigation/app_navigation_drawer.dart';
import 'package:workorder_company_app/shared/page/loading_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/navigation/app_navigation_bar.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final path = GoRouterState.of(context).uri.path;

    if (authState is! Authenticated) {
      return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              context.go(AppRoutes.login);
            }
          },
          child: LoadingPage());
    }
    // HACK: Temporary redirect handling inside AppLayout. the method is give new listner on LoadingPage
    // This is needed because some routes are still wrapped by ShellRoute
    //
    // The issue started after the profile page was moved into the ShellRoute
    // to resolve notification redirection triggered via snackbar
    //
    // Side effect:
    // - Certain pages (e.g. Profile) may still render under AppLayout
    //   during logout transition and cannot redirect properly
    // - During AuthLoading, AppLayout does not render the current route.
    // - As a result, BlocListener (in profile page and general listener) does not trigger.

    final role = authState.user.role;
    final bool isMainPage = _roleMainPages[role]?.contains(path) ?? false;

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return AuthenticatedBlocProvider(
      child: GeneralListener(
        child: Scaffold(
          appBar: isMainPage && isLandscape ? AppBar() : null,
          drawer: isMainPage && isLandscape
              ? AppNavigationDrawer(role: role)
              : null,
          bottomNavigationBar:
              isMainPage && !isLandscape ? AppNavigationBar(role: role) : null,
          body: child,
        ),
      ),
    );
  }
}

final Map<UserRole, List<String>> _roleMainPages = {
  UserRole.ownerCompany: [
    AppRoutes.home,
    AppRoutes.companyManageMenu,
  ],
  UserRole.managerCompany: [
    AppRoutes.home,
    AppRoutes.serviceRequestInbox,
    AppRoutes.workOrders
  ],
  UserRole.staffCompany: [
    AppRoutes.home,
    AppRoutes.workOrders,
  ],
  UserRole.staffUnassigned: [
    AppRoutes.home,
    AppRoutes.invitationsPending,
  ],
  UserRole.client: [
    AppRoutes.home,
    AppRoutes.publicCompanies,
  ],
};
