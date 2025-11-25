import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';

class HorizontalButton extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const HorizontalButton({
    super.key,
    this.leadingIcon = Icons.settings, // default icon
    required this.title,
    this.description,
    this.onTap,
    this.padding = const EdgeInsets.all(8),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final hasDescription = description != null && description!.isNotEmpty;

    return CustomCard(
        padding: const EdgeInsets.all(0),
        margin: margin,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: padding,
              child: Row(
                children: [
                  // leading icon
                  Icon(
                    leadingIcon,
                    size: 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),

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
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                        ]
                      ],
                    ),
                  ),

                  const Icon(Icons.chevron_right, size: 24),
                ],
              ),
            )));
  }
}
