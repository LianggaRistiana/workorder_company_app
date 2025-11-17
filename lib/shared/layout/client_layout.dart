import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_bloc.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/fetch_company/company_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_navigation_bar.dart';
class ClientLayout extends StatefulWidget {
  final Widget child;
  const ClientLayout({super.key, required this.child});

  @override
  State<ClientLayout> createState() => _ClientLayoutState();
}

class _ClientLayoutState extends State<ClientLayout> {
  int _currentIndex = 0;

  final List<NavItem> _navItems = const [
    NavItem('Home', Icons.home_rounded, AppRoutes.clientHome),
    NavItem('Company', Icons.home_work_rounded, AppRoutes.clientCompanyPortal),
    NavItem('Profile', Icons.account_circle_rounded, AppRoutes.clientProfile),
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    final currentLocation = GoRouterState.of(context).uri.toString();

    final targetRoute = _navItems[index].route;
    if (!currentLocation.startsWith(targetRoute)) {
      context.go(targetRoute);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = GoRouterState.of(context).uri.toString();
    final newIndex = _navItems.indexWhere((r) => loc.startsWith(r.route));
    if (newIndex != -1) {
      _currentIndex = newIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CompanyBloc>()),
        BlocProvider(create: (_) => sl<CsrBloc>()),
      ],
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: CustomNavigationBar(
          items: _navItems,
          currentIndex: _currentIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
