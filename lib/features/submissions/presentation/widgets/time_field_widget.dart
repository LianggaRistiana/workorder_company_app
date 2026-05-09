import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/item_tile_lined.dart';

class TimeFieldWidget extends StatelessWidget {
  final FieldEntity field;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const TimeFieldWidget({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
  });

  TimeOfDay? get initialTime {
    final value = this.value;

    if (value == null) return null;

    return TimeOfDay.fromDateTime(value);
  }

  Future<void> _pickTime(
    BuildContext context,
    ValueChanged<TimeOfDay> didChange,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      final current = value ?? DateTime.now();

      final result = DateTime(
        current.year,
        current.month,
        current.day,
        picked.hour,
        picked.minute,
      );
      didChange(picked);
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialTime,
      validator: (val) {
        if (field.required && val == null) return "${field.label} wajib diisi";
        return null;
      },
      builder: (fieldItem) {
        final hasError = (fieldItem.errorText?.isNotEmpty ?? false);
        final errorMessage = fieldItem.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label,
                style: hasError
                    ? Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error)
                    : Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ClickableCustomCard(
              borderColor:
                  hasError ? Theme.of(context).colorScheme.error : null,
              onTap: () {
                _pickTime(context, (val) => fieldItem.didChange(val));
              },
              child: ItemTileLined(
                lineColor:
                    hasError ? Theme.of(context).colorScheme.error : null,
                child: Text(initialTime?.format(context) ?? 'Pilih Waktu',
                    style: hasError
                        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error)
                        : Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            if (!hasError &&
                field.placeholder != null &&
                field.placeholder!.isNotEmpty)
              Text(
                field.placeholder!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            if (hasError)
              Text(
                errorMessage ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
          ],
        );
      },
    );
  }
}
