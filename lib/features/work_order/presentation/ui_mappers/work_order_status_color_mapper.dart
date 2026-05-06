import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

extension WorkOrderStatusColorMapper on WorkOrderStatus {
  Color get color {
    return switch (this) {
      WorkOrderStatus.drafted => Colors.grey,
      WorkOrderStatus.sent => const Color.fromARGB(255, 106, 188, 255),
      WorkOrderStatus.approved => Colors.blueAccent,
      WorkOrderStatus.onProgress => Colors.orange,
      WorkOrderStatus.completed => const Color.fromARGB(255, 24, 184, 29),
      WorkOrderStatus.rejected => Colors.red,
      WorkOrderStatus.cancelled => Colors.redAccent,
      WorkOrderStatus.failed => Colors.deepOrange,
    };
  }
}
