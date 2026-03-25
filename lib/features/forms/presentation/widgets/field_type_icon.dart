import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class FieldTypeIcon extends StatelessWidget {
  final FieldType type;

  const FieldTypeIcon({super.key, required this.type});

  IconData _getIcon(FieldType type) {
    switch (type) {
      case FieldType.text:
        return AppIcon.textField;
      case FieldType.email:
        return AppIcon.emailField;
      case FieldType.textarea:
        return AppIcon.textareaField;
      case FieldType.number:
        return AppIcon.numberField;
      case FieldType.date:
        return AppIcon.dateField;
      case FieldType.time:
        return AppIcon.timeField;
      case FieldType.multiSelect:
        return AppIcon.multiSelect;
      case FieldType.singleSelect:
        return AppIcon.singleSelect;
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
