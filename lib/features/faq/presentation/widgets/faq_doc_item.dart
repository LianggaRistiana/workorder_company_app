import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class FaqDocItem extends StatelessWidget {
  final FaqDocEntity doc;

  const FaqDocItem({
    super.key,
    required this.doc,
  });

  // TODO : add drawer to detail
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClickableCustomCard(
        margin: EdgeInsets.only(
          bottom: AppSpacing.sm,
          left: AppSpacing.md,
          right: AppSpacing.md,
        ),
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              IconBox.small(icon: AppIcon.file),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                  child: Text(
                doc.title,
                style: theme.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Text(
              doc.content,
              style: theme.textTheme.bodySmall,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ));
  }
}
