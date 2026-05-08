import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_report_enum.dart';

extension WorkReportStatusColorMapper on WorkReportStatus {
  Color get color {
    return switch (this) {
      WorkReportStatus.sent => const Color.fromARGB(255, 106, 188, 255),
      WorkReportStatus.approved => Colors.blueAccent,
      WorkReportStatus.onProgress => Colors.orange,
      WorkReportStatus.rejected => Colors.red,
    };
  }
}
