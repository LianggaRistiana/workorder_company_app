import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class IconBox extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double paddingSize;
  final double borderRadius;
  const IconBox(
      {super.key,
      required this.icon,
      this.iconSize = 28,
      this.paddingSize = AppSpacing.md,
      this.borderRadius = AppRadius.medium});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(paddingSize),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
