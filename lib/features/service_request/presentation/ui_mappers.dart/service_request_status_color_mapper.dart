import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';

extension ServiceRequestStatusColorMapper on ServiceRequestStatus {
  Color get color {
    return switch (this) {
      ServiceRequestStatus.received => Colors.grey,
      ServiceRequestStatus.cancelled => Colors.redAccent,
      ServiceRequestStatus.rejected => Colors.red,
      ServiceRequestStatus.approved => Colors.blue,
      ServiceRequestStatus.onProgress => Colors.orange,
      ServiceRequestStatus.unProcessable => const Color.fromARGB(255, 213, 121, 93),
      ServiceRequestStatus.completed => Colors.green,
      ServiceRequestStatus.partiallyCompleted => Colors.amber,
      ServiceRequestStatus.closed => Colors.black,
    };
  }
}
