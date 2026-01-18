import 'package:flutter/material.dart';

// TODO : Implement this later
class AdaptiveWrapper extends StatelessWidget {
  final Widget compact; // HP portrait
  final Widget medium; // HP landscape / tablet portrait
  final Widget expanded; // Tablet landscape / desktop

  const AdaptiveWrapper({
    super.key,
    required this.compact,
    required this.medium,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;

        if (width >= 840) {
          return expanded;
        } else if (width >= 600) {
          return medium;
        } else {
          return compact;
        }
      },
    );
  }
}
