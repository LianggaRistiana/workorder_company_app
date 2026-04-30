import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

extension FieldTypeIconMapper on FieldType {
  IconData get icon {
    return switch (this) {
      FieldType.text => LucideIcons.caseSensitive,
      FieldType.email => Icons.alternate_email,
      FieldType.textarea => Icons.notes,
      FieldType.number => LucideIcons.sigma,
      FieldType.date => LucideIcons.calendar,
      FieldType.image => Icons.image,
      FieldType.time => Icons.access_time,
      FieldType.multiSelect => LucideIcons.listChecks,
      FieldType.singleSelect => Icons.radio_button_checked,
    };
  }
}
