import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/field_data_draft.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/media_item.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/time_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/email_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/image_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/multi_select_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/number_form_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/single_select_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/text_area_field_widget.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/text_form_field_widget.dart';

class FieldRenderer extends StatelessWidget {
  final FieldEntity field;
  final FieldDataDraft? value;
  final void Function(String order, dynamic value) onChanged;

  const FieldRenderer({
    super.key,
    required this.field,
    required this.onChanged,
    this.value,
  });

  num? normalizeToNum(dynamic value) {
    if (value == null) return null;

    if (value is num) return value;

    if (value is String) {
      final v = value.trim();
      if (v.isEmpty) return null;
      return num.tryParse(v);
    }

    return null;
  }

  MediaItem? _normalizeToMediaItem(dynamic value) {
    appLogger.i("normalizeToMediaItem: $value");
    if (value == null) return null;

    if (value is MediaItem) return value;

    if (value is String) {
      final v = value.trim();
      if (v.isEmpty) return null;
      return MediaItem(path: v, isNetwork: true);
    }

    return null;
  }

  DateTime? _normalizeToDateTime(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) return value;

    if (value is String) {
      final v = value.trim();

      if (v.isEmpty) return null;

      return DateTime.tryParse(v);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    switch (field.type) {
      case FieldType.text:
        return TextFormFieldWidget(
          field: field,
          value: value?.value as String?,
          onChanged: (val) => onChanged(field.order.toString(), val),
        );

      case FieldType.textarea:
        return TextAreaFieldWidget(
          field: field,
          value: value?.value as String?,
          onChanged: (val) => onChanged(field.order.toString(), val),
        );

      case FieldType.number:
        return NumberFormFieldWidget(
          field: field,
          value: normalizeToNum(value?.value),
          onChanged: (val) => onChanged(field.order.toString(), val),
        );

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
            field.order.toString(),
            vals.map((e) => e.key).toList(),
          ),
        );

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
            field.order.toString(),
            val?.key,
          ),
        );

      case FieldType.image:
        return ImageFieldWidget(
            field: field,
            onChanged: (val) {
              onChanged(field.order.toString(), val);
            },
            value: _normalizeToMediaItem(value?.value));

      case FieldType.email:
        return EmailFieldWidget(
          field: field,
          value: value?.value as String?,
          onChanged: (val) => onChanged(field.order.toString(), val),
        );

      case FieldType.time:
        return TimeFieldWidget(
            field: field,
            value: _normalizeToDateTime(value?.value),
            onChanged: (val) => onChanged(field.order.toString(), val));

      // TODO : add this type field render later
      case FieldType.date:
        return Text("Unsupported field type: ${field.type}");
    }
  }
}
