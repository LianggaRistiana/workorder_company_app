import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/presentation/ui_mappers/field_type_icon_mapper.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class FieldTypeIcon extends StatelessWidget {
  final FieldType type;

  const FieldTypeIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconBox.small(
          icon: type.icon,
        ),
        const SizedBox(width: 4),
        Text(type.displayName, style: Theme.of(context).textTheme.titleSmall)
      ],
    );
  }
}
