import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class FieldTypeChip extends StatelessWidget {
  final FieldType type;
  final bool showLabel;
  final Color? backgroundColor;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;

  const FieldTypeChip({
    super.key,
    required this.type,
    this.showLabel = true,
    this.backgroundColor,
    this.iconColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // final brightness = Theme.of(context).brightness;
    // final bgColor = backgroundColor ??
    //     (brightness == Brightness.light
    //         ? Colors.grey.shade200
    //         : Colors.grey.shade800);
    // final iconClr = iconColor ??
    //     (brightness == Brightness.light
    //         ? Colors.grey.shade800
    //         : Colors.white70);

    return Chip(
      // backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(type), size: 18),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              type.displayName,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              // style: TextStyle(color: iconClr),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIcon(FieldType type) {
    switch (type) {
      case FieldType.text:
        return Icons.text_fields;
      case FieldType.textarea:
        return Icons.notes;
      case FieldType.number:
        return Icons.pin;
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
}
