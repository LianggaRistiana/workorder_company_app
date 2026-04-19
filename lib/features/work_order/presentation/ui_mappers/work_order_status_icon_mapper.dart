import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

extension WorkOrderStatusIconMapper on WorkOrderStatus {
  IconData get icon {
    return switch (this) {
      WorkOrderStatus.drafted => LucideIcons.edit,
      WorkOrderStatus.sent => LucideIcons.send,
      WorkOrderStatus.approved => Icons.check,
      WorkOrderStatus.onProgress => Icons.timelapse_rounded,
      WorkOrderStatus.rejected => LucideIcons.ban,
      WorkOrderStatus.cancelled => LucideIcons.xCircle,
      WorkOrderStatus.failed => LucideIcons.alertCircle,
      WorkOrderStatus.completed => LucideIcons.checkCircle,
    };
  }
}
