import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/features/service_request/presentation/ui_mappers.dart/service_request_status_color_mapper.dart';
import 'package:workorder_company_app/features/service_request/presentation/ui_mappers.dart/service_request_status_icon_mapper.dart';

class ServiceRequestStatusIcon extends StatelessWidget {
  final ServiceRequestStatus status;

  const ServiceRequestStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: status.color.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(status.icon, color: status.color, size: 28),
    );
  }
}
