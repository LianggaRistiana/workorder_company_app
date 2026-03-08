import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_access_chip.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';

class ServiceItem extends StatelessWidget {
  final ServiceEntity service;
  final bool isPublic;
  final VoidCallback? onTap;

  const ServiceItem(
      {super.key, required this.service, this.isPublic = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(0),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.build_circle_outlined,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(
          service.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          service.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isPublic
            ? Icon(
                Icons.chevron_right,
              )
            : ServiceAccessChip(access: service.accessType),
        onTap: onTap,
      ),
    );
  }
}
