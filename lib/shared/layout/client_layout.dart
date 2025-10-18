import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class ClientLayout extends StatefulWidget {
  final Widget child;
  const ClientLayout({super.key, required this.child});

  @override
  State<ClientLayout> createState() => _ClientLayoutState();
}

class _ClientLayoutState extends State<ClientLayout> {
  int _currentIndex = 0;

  // Navigation
  final List<_NavItem> _navItems = [
    _NavItem('Home', Icons.home_rounded, AppRoutes.clientHome),
    _NavItem('Company', Icons.home_work_rounded, AppRoutes.clientCompanyPortal),
    _NavItem('Profile', Icons.account_circle_rounded, AppRoutes.clientProfile), 
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: _navItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;

  const _NavItem(this.label, this.icon, this.route);
}
