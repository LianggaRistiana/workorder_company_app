import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/shared/layout/navigation/nav_config.dart';
import 'package:workorder_company_app/shared/widgets/custom_navigation_bar.dart';

class AppNavigationBar extends StatefulWidget {
  final UserRole role;

  const AppNavigationBar({super.key, required this.role});

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _currentIndex = 0;

  late final List<NavItem> _items;

  @override
  void initState() {
    super.initState();
    _items = NavConfig.byRole(widget.role);
  }

 void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    final currentLocation = GoRouterState.of(context).uri.toString();

    final targetRoute = _items[index].route;
    if (!currentLocation.startsWith(targetRoute)) {
      context.go(targetRoute);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = GoRouterState.of(context).uri.toString();
    final newIndex = _items.indexWhere((r) => loc.startsWith(r.route));
    if (newIndex != -1) {
      _currentIndex = newIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomNavigationBar(
      items: _items,
      currentIndex: _currentIndex,
      onItemTapped: _onItemTapped,
    );
  }
}
