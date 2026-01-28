import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';

class HorizontalSwitch extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final bool isDanger;
  final bool enabled;

  const HorizontalSwitch({
    super.key,
    this.leadingIcon,
    required this.title,
    this.description,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.all(8),
    this.margin,
    this.isDanger = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasIcon = leadingIcon != null;
    final hasDescription = description != null && description!.isNotEmpty;

    return CustomCard(
      padding: EdgeInsets.zero,
      margin: margin,
      borderColor: isDanger ? Theme.of(context).colorScheme.error : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              // 🔹 optional icon
              if (hasIcon) ...[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDanger
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    leadingIcon,
                    size: 24,
                    color: isDanger
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // title + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      hasDescription ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: isDanger
                          ? Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.error)
                          : Theme.of(context).textTheme.titleMedium,
                    ),
                    if (hasDescription) ...[
                      const SizedBox(height: 4),
                      Text(
                        description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDanger
                                  ? Theme.of(context)
                                      .colorScheme
                                      .error
                                      .withAlpha(120)
                                  : Colors.grey[600],
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // switch
              Switch(
                value: value,
                onChanged: enabled ? onChanged : null,
                activeColor: isDanger
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
