import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';

enum HelpButtonType {
  block,
  iconOnly,
}

class HelpButton extends StatelessWidget {
  final Widget child;
  final String title;
  final HelpButtonType type;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;

  const HelpButton({
    super.key,
    required this.child,
    this.title = "Tips dan petunjuk",
    this.type = HelpButtonType.block,
    this.padding,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HelpButtonType.block:
        return _buildBlock(context);
      case HelpButtonType.iconOnly:
        return _buildTrailing(context);
    }
  }

  Widget _buildBlock(BuildContext context) {
    final colors = _resolveColors(context);

    return Card(
      elevation: 0,
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      color: colors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => _openBottomSheet(context, colors),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tips_and_updates, color: colors.textColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: colors.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    final colors = _resolveColors(context);

    return IconButton.filled(
      tooltip: title,
      style: IconButton.styleFrom(
        backgroundColor: colors.backgroundColor,
      ),
      onPressed: () => _openBottomSheet(context, colors),
      icon: Icon(
        Icons.tips_and_updates,
        color: colors.textColor,
      ),
    );
  }

  _HelpButtonColors _resolveColors(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    return _HelpButtonColors(
      backgroundColor:
          darkMode ? Colors.yellow.withAlpha(50) : Colors.yellow.withAlpha(75),
      textColor: darkMode ? Colors.amber : Colors.black,
    );
  }

  void _openBottomSheet(BuildContext context, _HelpButtonColors colors) {
    showAppBottomSheet(
      context,
      header: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tips_and_updates, color: colors.textColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: colors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton(
            onPressed: () => context.pop(),
            child: const Text("Tutup"),
          ),
        ],
      ),
      content: child,
    );
  }
}

class _HelpButtonColors {
  final Color backgroundColor;
  final Color textColor;

  const _HelpButtonColors({
    required this.backgroundColor,
    required this.textColor,
  });
}
