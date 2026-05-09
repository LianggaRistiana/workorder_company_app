import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/item_tile_lined.dart';

class DateFieldWidget extends StatelessWidget {
  final FieldEntity field;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const DateFieldWidget({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
  });

  DateTime? get initialDate {
    return value?.toLocal();
  }

  String get buttonString {
    if (initialDate == null) return 'Pilih Tanggal';
    return DateFormat('d MMM yyyy', 'id_ID').format(initialDate!);
  }

  Future<void> _pickTime(
    BuildContext context,
    ValueChanged<DateTime> didChange,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      didChange(picked);
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: value,
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
                child: Text(buttonString,
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
