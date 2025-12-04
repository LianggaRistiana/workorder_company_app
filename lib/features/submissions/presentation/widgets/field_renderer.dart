import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/multi_select_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/number_form_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/single_select_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/text_form_field_widget.dart';

class FieldRenderer extends StatelessWidget {
  final String formId;
  final FieldEntity field;
  final void Function(String formId, String order, dynamic value) onChanged;

  const FieldRenderer({
    super.key,
    required this.formId,
    required this.field,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (field.type) {
      case FieldType.text:
        return TextFormFieldWidget(
          field: field,
          onChanged: (val) =>
              onChanged(formId, field.order.toString(), val),
        );

      case FieldType.number:
        return NumberFormFieldWidget(
          field: field,
          onChanged: (val) =>
              onChanged(formId, field.order.toString(), val),
        );

      case FieldType.multiSelect:
        return MultiSelectFormFieldWidget(
          field: field,
          initialValue: [],
          onChanged: (vals) => onChanged(
            formId,
            field.order.toString(),
            vals.map((e) => e.key).toList(),
          ),
        );

      case FieldType.singleSelect:
        return SingleSelectFormFieldWidget(
          field: field,
          initialValue: null,
          onChanged: (val) =>
              onChanged(formId, field.order.toString(), val?.key),
        );

      default:
        return Text("Unsupported field type: ${field.type}");
    }
  }
}
