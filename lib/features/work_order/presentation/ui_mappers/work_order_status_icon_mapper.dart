import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

extension WorkOrderStatusIconMapper on WorkOrderStatus {
  IconData get icon {
    return switch (this) {
      WorkOrderStatus.drafted => LucideIcons.edit,
      WorkOrderStatus.sent => LucideIcons.send,
      WorkOrderStatus.approved => Icons.check,
      WorkOrderStatus.onProgress => Icons.timelapse_rounded,
      WorkOrderStatus.rejected => LucideIcons.xCircle,
      WorkOrderStatus.cancelled => AppIcon.cancel,
      WorkOrderStatus.failed => LucideIcons.alertCircle,
      WorkOrderStatus.completed => LucideIcons.checkCircle,
    };
  }
}
