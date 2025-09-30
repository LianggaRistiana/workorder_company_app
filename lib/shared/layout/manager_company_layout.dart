import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManagerCompanyLayout extends StatefulWidget {
  final Widget child;
  const ManagerCompanyLayout({super.key, required this.child});

  @override
  State<ManagerCompanyLayout> createState() => _ManagerCompanyLayoutState();
}

class _ManagerCompanyLayoutState extends State<ManagerCompanyLayout> {
  int _currentIndex = 0;

  final List<String> _routes = [
    '/manager/dashboard',
    '/manager/profile',
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
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
