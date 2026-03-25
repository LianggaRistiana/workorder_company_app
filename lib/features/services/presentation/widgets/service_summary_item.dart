import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class ServiceSummaryItem extends StatelessWidget {
  final ServiceSummaryEntity service;
  final bool isPublic;
  final VoidCallback? onTap;

  const ServiceSummaryItem(
      {super.key, required this.service, this.isPublic = true, this.onTap});

  Color _accessColor(ServiceAccessType type) {
    switch (type) {
      case ServiceAccessType.public:
        return Colors.green;
      case ServiceAccessType.memberOnly:
        return Colors.blue;
      case ServiceAccessType.internal:
        return Colors.orange;
    }
  }

  IconData _accessIcon(ServiceAccessType type) {
    switch (type) {
      case ServiceAccessType.public:
        return Icons.public;
      case ServiceAccessType.memberOnly:
        return Icons.workspace_premium_rounded;
      case ServiceAccessType.internal:
        return Icons.business_center_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClickableCustomCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            IconBox(icon: AppIcon.service),
            if (!isPublic) ...[
              const SizedBox(height: 8),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: _accessColor(service.accessType),
                  child: Icon(
                    _accessIcon(service.accessType),
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              )
            ]
          ]),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                service.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
