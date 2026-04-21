import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class IconBox extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double paddingSize;
  final double borderRadius;
  final bool isDisabled;

  const IconBox(
      {super.key,
      required this.icon,
      this.iconSize = 28,
      this.isDisabled = false,
      this.paddingSize = AppSpacing.md,
      this.borderRadius = AppRadius.medium});

  const IconBox.small(
    {super.key,
      required this.icon,
      this.iconSize = 18,
      this.isDisabled = false,
      this.paddingSize = AppSpacing.sm,
      this.borderRadius = AppRadius.small}
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(paddingSize),
      decoration: BoxDecoration(
        color: isDisabled
            ? Theme.of(context).hoverColor
            : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: isDisabled
            ? Theme.of(context).disabledColor
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
