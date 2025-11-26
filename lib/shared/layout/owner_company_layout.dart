import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_navigation_bar.dart';
class OwnerCompanyLayout extends StatefulWidget {
  final Widget child;
  const OwnerCompanyLayout({super.key, required this.child});

  @override
  State<OwnerCompanyLayout> createState() => _OwnerCompanyLayoutState();
}

class _OwnerCompanyLayoutState extends State<OwnerCompanyLayout> {
  int _currentIndex = 0;

  final List<NavItem> _navItems = const [
    NavItem('Home', Icons.home_rounded, AppRoutes.ownerHome),
    NavItem('Company', Icons.home_work_rounded, AppRoutes.ownerCompany),
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
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomNavigationBar(
        items: _navItems,
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
