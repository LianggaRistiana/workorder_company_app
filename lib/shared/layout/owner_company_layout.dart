import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class OwnerCompanyLayout extends StatefulWidget {
  final Widget child;
  const OwnerCompanyLayout({super.key, required this.child});

  @override
  State<OwnerCompanyLayout> createState() => _OwnerCompanyLayout();
}

class _OwnerCompanyLayout extends State<OwnerCompanyLayout> {
  int _currentIndex = 0;

  final List<String> _routes = [
    AppRoutes.ownerHome,
    AppRoutes.ownerCompany,
    AppRoutes.ownerEmployee,
    AppRoutes.ownerProfile
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    final currentLocation = GoRouterState.of(context).uri.toString();
    if (_routes[index] != currentLocation) {
      context.go(_routes[index]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sinkronisasi currentIndex dengan route aktif
    final loc = GoRouterState.of(context).uri.toString();
    final newIndex = _routes.indexWhere((r) => loc.startsWith(r));
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work_rounded),
            label: 'Company',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
