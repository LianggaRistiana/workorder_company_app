import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/chat_item_entity.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class ChatBubble extends StatelessWidget {
  final ChatItemEntity item;

  const ChatBubble({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final widthSpace = MediaQuery.of(context).size.width;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Align(
          alignment: Alignment.centerRight,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppRadius.large),
                ),
                color: theme.colorScheme.primary,
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(
                  left: AppSpacing.lg, bottom: AppSpacing.sm),
              child: Text(
                item.userQuery,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ))),
      const SizedBox(height: 8),
      _botChat(widthSpace, theme)
    ]);
  }

  // TODO : add error response UI
  Widget _botChat(double widthSpace, ThemeData theme) {
    final firstLength = widthSpace * 0.7;
    final secondLength = widthSpace * 0.5;
    return Align(
        alignment: Alignment.centerLeft,
        child: item.state == ChatState.waiting
            ? SmartShimmer(
                placeholders: [
                  ShimmerPlaceholder(height: 10, width: firstLength),
                  const SizedBox(height: 8),
                  ShimmerPlaceholder(height: 10, width: secondLength),
                  const SizedBox(height: 8),
                  ShimmerPlaceholder(height: 10, width: secondLength),
                  const SizedBox(height: 8),
                  ShimmerPlaceholder(height: 10, width: secondLength),
                  const SizedBox(height: 8),
                  ShimmerPlaceholder(height: 10, width: secondLength),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(
                    right: AppSpacing.lg, bottom: AppSpacing.lg),
                child: Text(item.botResponse ?? "",
                    style: theme.textTheme.bodyLarge),
              ));
  }
}
