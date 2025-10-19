import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Reusable Navigation Bar
class CustomNavigationBar extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onItemTapped,
      indicatorColor: colorScheme.primaryContainer,
      backgroundColor: colorScheme.surface,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      destinations: items.map((item) {
        final isSelected = items.indexOf(item) == currentIndex;
        return NavigationDestination(
          icon: Icon(
            item.icon,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
          label: item.label,
        );
      }).toList(),
    );
  }
}

/// Reusable NavItem class
class NavItem {
  final String label;
  final IconData icon;
  final String route;

  const NavItem(this.label, this.icon, this.route);
}