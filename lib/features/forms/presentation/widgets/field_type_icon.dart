import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class FieldTypeIcon extends StatelessWidget {
  final FieldType type;

  const FieldTypeIcon({super.key, required this.type});

  IconData _getIcon(FieldType type) {
    switch (type) {
      case FieldType.text:
        return Icons.text_format;
      case FieldType.email:
        return Icons.alternate_email;
      case FieldType.textarea:
        return Icons.notes;
      case FieldType.number:
        return Icons.numbers_outlined;
      case FieldType.date:
        return Icons.calendar_today;
      case FieldType.time:
        return Icons.access_time;
      case FieldType.multiSelect:
        return Icons.checklist;
      case FieldType.singleSelect:
        return Icons.radio_button_checked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconBox(
          icon: _getIcon(type),
          paddingSize: 8,
          borderRadius: 8,
          iconSize: 18,
        ),
        const SizedBox(width: 4),
        Text(type.displayName, style: Theme.of(context).textTheme.titleSmall)
      ],
    );
  }
}
