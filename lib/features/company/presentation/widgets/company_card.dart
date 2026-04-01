import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class CompanyCard extends StatelessWidget {
  final CompanyEntity company;
  final VoidCallback? onTap;

  const CompanyCard({
    super.key,
    required this.company,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClickableCustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(0),
      margin:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconBox(icon: AppIcon.company),
              const SizedBox(width: 12),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (company.address.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              company.address,
                              maxLines: 1,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
