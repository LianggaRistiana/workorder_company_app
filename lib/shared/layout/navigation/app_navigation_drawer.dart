import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/current_user_chip.dart';
import 'package:workorder_company_app/features/notification/presentation/widgets/notification_button_tile.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/navigation/nav_config.dart';
import 'package:workorder_company_app/shared/layout/widget/custom_navigation_bar.dart';

class AppNavigationDrawer extends StatefulWidget {
  final UserRole role;

  const AppNavigationDrawer({super.key, required this.role});

  @override
  State<AppNavigationDrawer> createState() => _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends State<AppNavigationDrawer> {
  int _currentIndex = 0;
  late final List<NavItem> _items;

  @override
  void initState() {
    super.initState();
    _items = NavConfig.byRole(widget.role);
  }

  void _onItemTapped(int index) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final targetRoute = _items[index].route;

    if (!currentLocation.startsWith(targetRoute)) {
      context.go(targetRoute);
    }

    setState(() => _currentIndex = index);

    Navigator.of(context).pop(); // tutup drawer
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final loc = GoRouterState.of(context).uri.toString();
    final newIndex = _items.indexWhere((r) => loc.startsWith(r.route));

    if (newIndex != -1 && newIndex != _currentIndex) {
      setState(() => _currentIndex = newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: CurrentUserChip(
                onTap: () {
                  context.push(AppRoutes.profile);
                },
              ),
            ),
            NotificationButtonTile(),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final isSelected = index == _currentIndex;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Material(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        selected: isSelected,
                        leading: Icon(item.icon),
                        title: Text(item.label),
                        onTap: () => _onItemTapped(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
