import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/features/service_request/presentation/ui_mappers.dart/service_request_status_color_mapper.dart';
import 'package:workorder_company_app/features/service_request/presentation/ui_mappers.dart/service_request_status_icon_mapper.dart';

class ServiceRequestStatusChip extends StatelessWidget {
  final ServiceRequestStatus status;
  final bool showIcon;

  const ServiceRequestStatusChip(
      {super.key, required this.status, required this.showIcon});

  @override
  Widget build(BuildContext context) {
    final label = status.displayName;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withAlpha(50),
        borderRadius: BorderRadius.circular(20), // chip style
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              status.icon,
              color: status.color,
              size: 18,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
