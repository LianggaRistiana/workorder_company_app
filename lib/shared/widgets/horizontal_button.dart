import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';

class HorizontalButton extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final bool isDanger;

  const HorizontalButton(
      {super.key,
      this.leadingIcon = Icons.settings, // default icon
      required this.title,
      this.description,
      this.onTap,
      this.padding = const EdgeInsets.all(8),
      this.margin,
      this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    final hasDescription = description != null && description!.isNotEmpty;

    return CustomCard(
        padding: const EdgeInsets.all(0),
        borderColor: isDanger ? Theme.of(context).colorScheme.error : null,
        margin: margin,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // leading icon
                  // Icon(
                  //   leadingIcon,
                  //   size: 28,
                  //   color: isDanger
                  //       ? Theme.of(context).colorScheme.error
                  //       : Theme.of(context).colorScheme.primary,
                  // ),
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

                  // title + description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: isDanger
                                ? Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error
                                          .withAlpha(98),
                                    )
                                : Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                        ]
                      ],
                    ),
                  ),

                  Icon(
                    Icons.chevron_right,
                    size: 24,
                    color:
                        isDanger ? Theme.of(context).colorScheme.error : null,
                  ),
                ],
              ),
            )));
  }
}
