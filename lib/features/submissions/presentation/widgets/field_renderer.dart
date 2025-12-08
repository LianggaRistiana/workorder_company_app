import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/multi_select_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/number_form_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/single_select_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/text_form_field_widget.dart';

class FieldRenderer extends StatelessWidget {
  final String formId;
  final FieldEntity field;
  final FieldDataEntity? value;
  final void Function(String formId, String order, dynamic value) onChanged;

  const FieldRenderer({
    super.key,
    required this.formId,
    required this.field,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    switch (field.type) {
      case FieldType.text:
        return TextFormFieldWidget(
          field: field,
          value: value?.value as String?,
          onChanged: (val) => onChanged(formId, field.order.toString(), val),
        );

      // return TextFormFieldWidget(
      //   field: field,
      //   onChanged: (val) => onChanged(formId, field.order.toString(), val),
      // );

      case FieldType.number:
        return NumberFormFieldWidget(
          field: field,
          value: value?.value, // biasanya num atau int
          onChanged: (val) => onChanged(formId, field.order.toString(), val),
        );
      // return NumberFormFieldWidget(
      //   field: field,
      //   onChanged: (val) => onChanged(formId, field.order.toString(), val),
      // );

      case FieldType.multiSelect:
        final savedKeys = (value?.value as List?)?.cast<String>() ?? [];

        final initialValues = field.options
                ?.where((opt) => savedKeys.contains(opt.key))
                .toList() ??
            [];

        return MultiSelectFormFieldWidget(
          field: field,
          initialValue: initialValues,
          onChanged: (vals) => onChanged(
            formId,
            field.order.toString(),
            vals.map((e) => e.key).toList(),
          ),
        );

      // return MultiSelectFormFieldWidget(
      //   field: field,
      //   initialValue: [],
      //   onChanged: (vals) => onChanged(
      //     formId,
      //     field.order.toString(),
      //     vals.map((e) => e.key).toList(),
      //   ),
      // );

      case FieldType.singleSelect:
        final savedKey = value?.value as String?;

        final initialOption = field.options
            ?.where(
              (opt) => opt.key == savedKey,
            )
            .firstOrNull;

        return SingleSelectFormFieldWidget(
          field: field,
          initialValue: initialOption,
          onChanged: (val) => onChanged(
            formId,
            field.order.toString(),
            val?.key,
          ),
        );
      // return SingleSelectFormFieldWidget(
      //   field: field,
      //   initialValue: null,
      //   onChanged: (val) =>
      //       onChanged(formId, field.order.toString(), val?.key),
      // );

      default:
        return Text("Unsupported field type: ${field.type}");
    }
  }
}
