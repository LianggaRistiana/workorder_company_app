import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

/// =============================
/// DATA MODEL
/// =============================
class PropertyItem {
  final String label;
  final IconData? icon;
  final String? value;
  final Widget? child;

  const PropertyItem.text({
    required this.label,
    required String this.value,
    this.icon,
  }) : child = null;

  const PropertyItem.widget({
    required this.label,
    required Widget this.child,
    this.icon,
  }) : value = null;
}

/// =============================
/// DISPLAY CONTAINER
/// =============================
class PropertyDisplay extends StatelessWidget {
  final List<PropertyItem> properties;
  final bool showDivider;

  const PropertyDisplay({
    super.key,
    required this.properties,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(properties.length, (index) {
        final item = properties[index];

        return Column(
          children: [
            PropertyTile(
              label: item.label,
              icon: item.icon,
              value: item.value,
              child: item.child,
            ),
            if (showDivider && index != properties.length - 1)
              const Divider(height: 24),
          ],
        );
      }),
    );
  }
}

/// =============================
/// MAIN TILE (UNIFIED)
/// =============================
class PropertyTile extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? value;
  final Widget? child;

  const PropertyTile({
    super.key,
    required this.label,
    this.icon,
    this.value,
    this.child,
  }) : assert(
          (value != null && child == null) ||
              (value == null && child != null),
          'PropertyTile must have either value OR child, not both.',
        );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          PropertyTitle(
            label: label,
            icon: icon,
          ),

          const SizedBox(height: 6),

          /// Content (Text or Widget)
          Padding(
            padding: icon != null
                ? const EdgeInsets.only(left: 45)
                : EdgeInsets.zero,
            child: value != null
                ? Text(
                    value!,
                    style: textTheme.bodyMedium,
                  )
                : child!,
          ),
        ],
      ),
    );
  }
}

/// =============================
/// TITLE COMPONENT
/// =============================
class PropertyTitle extends StatelessWidget {
  final String label;
  final IconData? icon;

  const PropertyTitle({
    super.key,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          IconBox(
            icon: icon!,
            paddingSize: 8,
            borderRadius: 8,
            iconSize: 18,
          ),
          const SizedBox(width: 10),
        ],
        Text(
          label,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}