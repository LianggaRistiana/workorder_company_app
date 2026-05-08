import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_report_enum.dart';
import 'package:lucide_icons/lucide_icons.dart';

extension WorkReportStatusIconMapper on WorkReportStatus {
  IconData get icon {
    return switch (this) {
      WorkReportStatus.sent => LucideIcons.send,
      WorkReportStatus.approved => Icons.check,
      WorkReportStatus.onProgress => Icons.timelapse_rounded,
      WorkReportStatus.rejected => LucideIcons.xCircle,
    };
  }
}
