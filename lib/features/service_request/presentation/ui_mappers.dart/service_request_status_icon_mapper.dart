import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:lucide_icons/lucide_icons.dart';

extension ServiceRequestStatusIconMapper on ServiceRequestStatus {
  IconData get icon {
    return switch (this) {
      ServiceRequestStatus.received => AppIcon.step,
      ServiceRequestStatus.cancelled => AppIcon.cancel,
      ServiceRequestStatus.rejected => LucideIcons.xCircle,
      ServiceRequestStatus.approved => Icons.check,
      ServiceRequestStatus.onProgress => Icons.timelapse_rounded,
      ServiceRequestStatus.unProcessable => LucideIcons.alertCircle,
      ServiceRequestStatus.completed => LucideIcons.checkCircle,
      ServiceRequestStatus.partiallyCompleted => Icons.rule_rounded,
      ServiceRequestStatus.closed => LucideIcons.lock,
    };
  }
}
