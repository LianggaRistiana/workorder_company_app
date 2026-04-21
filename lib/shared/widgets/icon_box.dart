import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class IconBox extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double paddingSize;
  final double borderRadius;
  final bool isDisabled;
  final Color? iconColor;
  final Color? backgroundColor;

  const IconBox(
      {super.key,
      required this.icon,
      this.iconSize = 28,
      this.isDisabled = false,
      this.paddingSize = AppSpacing.md,
      this.borderRadius = AppRadius.medium,
      this.iconColor,
      this.backgroundColor});

  const IconBox.small(
      {super.key,
      required this.icon,
      this.iconSize = 18,
      this.isDisabled = false,
      this.paddingSize = AppSpacing.sm,
      this.borderRadius = AppRadius.small,
      this.iconColor,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final iconColor = this.iconColor ?? Theme.of(context).colorScheme.primary;
    final backgroundColor =
        this.backgroundColor ?? Theme.of(context).colorScheme.primaryContainer;
    return Container(
      padding: EdgeInsets.all(paddingSize),
      decoration: BoxDecoration(
        color: isDisabled ? Theme.of(context).hoverColor : backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: isDisabled ? Theme.of(context).disabledColor : iconColor,
      ),
    );
  }
}
