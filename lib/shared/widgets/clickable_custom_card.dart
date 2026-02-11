import 'package:flutter/material.dart';

class ClickableCustomCard extends StatelessWidget {
  const ClickableCustomCard({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
    this.margin,
    this.elevation = 4,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final Color? borderColor;
  final double borderWidth;

  // 🔥 GANTI INI
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: elevation,
      shadowColor: Colors.black.withAlpha(60),
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: borderColor ?? theme.dividerColor.withAlpha(40),
          width: borderWidth,
        ),
      ),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }
}
