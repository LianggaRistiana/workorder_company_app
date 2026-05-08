import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class ItemTileLined extends StatelessWidget {
  final double spacing;
  final double lineWidth;
  final Widget child;
  final Color? lineColor;

  const ItemTileLined({
    super.key,
    required this.child,
    this.spacing = AppSpacing.md,
    this.lineWidth = 2,
    this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: lineWidth,
            decoration: BoxDecoration(
              color: lineColor ?? Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          SizedBox(width: spacing),
          Expanded(child: child),
        ],
      ),
    );
  }
}
