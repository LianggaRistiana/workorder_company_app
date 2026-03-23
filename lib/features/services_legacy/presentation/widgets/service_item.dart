import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/services_legacy/domain/entities/service_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class ServiceItem extends StatelessWidget {
  final ServiceEntity service;
  final bool isPublic;
  final VoidCallback? onTap;

  const ServiceItem(
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
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            IconBox(icon: Icons.build_circle_outlined),
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

  // @override
  // Widget build(BuildContext context) {
  //   return CustomCard(
  //     margin: const EdgeInsets.symmetric(
  //       horizontal: 0,
  //       vertical: AppSpacing.xs,
  //     ),
  //     padding: const EdgeInsets.all(0),
  //     child: ListTile(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       leading: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           IconBox(icon: Icons.build_circle_outlined)
  //         ]
  //       ),
  //       // leading: Container(
  //       //   padding: const EdgeInsets.all(12),
  //       //   decoration: BoxDecoration(
  //       //     color: Theme.of(context).colorScheme.primaryContainer,
  //       //     borderRadius: BorderRadius.circular(14),
  //       //   ),
  //       //   child: Icon(
  //       //     Icons.build_circle_outlined,
  //       //     size: 28,
  //       //     color: Theme.of(context).colorScheme.primary,
  //       //   ),
  //       // ),
  //       contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  //       title: Text(
  //         service.title,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       subtitle: Text(
  //         service.description,
  //         maxLines: 2,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //       // trailing: isPublic
  //       //     ? Icon(
  //       //         Icons.chevron_right,
  //       //       )
  //       //     : ServiceAccessChip(access: service.accessType),
  //       onTap: onTap,
  //     ),
  //   );
  // }
}
