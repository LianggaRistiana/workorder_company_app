import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

extension ResourceTypeIconMapper on ResourceType {
  IconData get icon {
    return switch (this) {
      ResourceType.invitation => AppIcon.invitation,
      ResourceType.workOrder => AppIcon.workOrder,
      _ => AppIcon.notification
    };
  }
}
