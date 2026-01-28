import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? leadingIcon;

  final bool value;
  final ValueChanged<bool>? onChanged;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool enabled;

  const CustomSwitchTile({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
    this.description,
    this.leadingIcon,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasDescription = description != null && description!.isNotEmpty;

    final bgColor = backgroundColor ??
        Theme.of(context).colorScheme.primaryContainer;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: enabled ? bgColor : bgColor.withAlpha(120),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                leadingIcon,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (hasDescription) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ]
              ],
            ),
          ),

          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}
