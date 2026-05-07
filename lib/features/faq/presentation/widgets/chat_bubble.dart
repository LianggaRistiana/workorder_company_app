import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/chat_item_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class ChatBubble extends StatelessWidget {
  final ChatItemEntity item;
  final VoidCallback? retry;

  const ChatBubble({
    super.key,
    required this.item,
    this.retry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final widthSpace = MediaQuery.of(context).size.width;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _userChat(theme),
      const SizedBox(height: 8),
      _botChat(widthSpace, theme)
    ]);
  }

  Widget _botChat(double widthSpace, ThemeData theme) {
    return Align(
        alignment: Alignment.centerLeft,
        child: item.state == ChatState.waiting
            ? _chatLoading(widthSpace)
            : item.state == ChatState.error
                ? _chatError(theme)
                : _chatSuccess(theme));
  }

  Widget _userChat(ThemeData theme) {
    return Align(
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
            )));
  }

  Widget _chatSuccess(ThemeData theme) {
    return Padding(
      padding:
          const EdgeInsets.only(right: AppSpacing.lg, bottom: AppSpacing.lg),
      child: Text(item.botResponse ?? "", style: theme.textTheme.bodyLarge),
    );
  }

  Widget _chatError(ThemeData theme) {
    return ClickableCustomCard(
      onTap: retry,
      borderColor: theme.colorScheme.error,
      borderRadius: BorderRadius.all(
        Radius.circular(AppRadius.large),
      ),
      margin:
          const EdgeInsets.only(right: AppSpacing.lg, bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcon.error,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(item.botResponse ?? "",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    )),
                const SizedBox(height: 8),
                Text("Klik untuk mengulang",
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatLoading(
    double widthSpace,
  ) {
    final firstLength = widthSpace * 0.7;
    final secondLength = widthSpace * 0.5;
    return SmartShimmer(
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
    );
  }
}
