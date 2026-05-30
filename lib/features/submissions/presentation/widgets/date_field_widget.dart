import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/item_tile_lined.dart';

class DateFieldWidget extends FormField<DateTime> {
  DateFieldWidget({
    super.key,
    required FieldEntity field,
    DateTime? value,
    required ValueChanged<DateTime> onChanged,
  }) : super(
          initialValue: value,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (val) {
            if (field.required && val == null) {
              return "${field.label} wajib diisi";
            }
            return null;
          },
          builder: (fieldState) {
            return _DateFieldContent(
              field: field,
              value: fieldState.value,
              errorText: fieldState.errorText,
              onChanged: (date) {
                fieldState.didChange(date);
                onChanged(date);
              },
            );
          },
        );
}

class _DateFieldContent extends StatelessWidget {
  final FieldEntity field;
  final DateTime? value;
  final String? errorText;
  final ValueChanged<DateTime> onChanged;

  const _DateFieldContent({
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
  });

  bool get hasError => errorText?.isNotEmpty ?? false;

  String get buttonString {
    if (value == null) return 'Pilih Tanggal';

    return DateFormat(
      'd MMM yyyy',
      'id_ID',
    ).format(value!.toLocal());
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    /// Normalize supaya aman dari timezone shifting
    final normalized = DateTime(
      picked.year,
      picked.month,
      picked.day,
    );

    onChanged(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: hasError
              ? Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: errorColor)
              : Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ClickableCustomCard(
          borderColor: hasError ? errorColor : null,
          onTap: () => _pickDate(context),
          child: ItemTileLined(
            lineColor: hasError ? errorColor : null,
            child: Text(
              buttonString,
              style: hasError
                  ? Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: errorColor)
                  : Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),

        /// Placeholder
        if (!hasError &&
            field.placeholder != null &&
            field.placeholder!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              field.placeholder!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),

        /// Error message
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: errorColor),
            ),
          ),
      ],
    );
  }
}

// class DateFieldWidget extends StatefulWidget {
//   final FieldEntity field;
//   final DateTime? value;
//   final ValueChanged<DateTime> onChanged;

//   const DateFieldWidget({
//     super.key,
//     required this.field,
//     this.value,
//     required this.onChanged,
//   });

//   @override
//   State<DateFieldWidget> createState() => _DateFieldWidgetState();
// }

// class _DateFieldWidgetState extends State<DateFieldWidget> {
//   DateTime? initialDate;

//   String get buttonString {
//     if (initialDate == null) return 'Pilih Tanggal';
//     return DateFormat('d MMM yyyy', 'id_ID').format(initialDate!);
//   }

//   @override
//   void initState() {
//     initialDate = widget.value?.toLocal();
//     super.initState();
//   }

//   Future<void> _pickTime(
//     BuildContext context,
//     ValueChanged<DateTime> didChange,
//   ) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: widget.value ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         initialDate = picked;
//       });
//       didChange(picked);
//       widget.onChanged(picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FormField<DateTime>(
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       initialValue: widget.value,
//       validator: (val) {
//         if (widget.field.required && val == null) {
//           return "${widget.field.label} wajib diisi";
//         }
//         return null;
//       },
//       builder: (fieldItem) {
//         final hasError = (fieldItem.errorText?.isNotEmpty ?? false);
//         final errorMessage = fieldItem.errorText;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.field.label,
//                 style: hasError
//                     ? Theme.of(context)
//                         .textTheme
//                         .titleSmall
//                         ?.copyWith(color: Theme.of(context).colorScheme.error)
//                     : Theme.of(context).textTheme.titleSmall),
//             const SizedBox(height: 8),
//             ClickableCustomCard(
//               borderColor:
//                   hasError ? Theme.of(context).colorScheme.error : null,
//               onTap: () {
//                 _pickTime(context, (val) => fieldItem.didChange(val));
//               },
//               child: ItemTileLined(
//                 lineColor:
//                     hasError ? Theme.of(context).colorScheme.error : null,
//                 child: Text(buttonString,
//                     style: hasError
//                         ? Theme.of(context).textTheme.bodyLarge?.copyWith(
//                             color: Theme.of(context).colorScheme.error)
//                         : Theme.of(context).textTheme.bodyLarge),
//               ),
//             ),
//             if (!hasError &&
//                 widget.field.placeholder != null &&
//                 widget.field.placeholder!.isNotEmpty)
//               Text(
//                 widget.field.placeholder!,
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodySmall
//                     ?.copyWith(color: Colors.grey[600]),
//               ),
//             if (hasError)
//               Text(
//                 errorMessage ?? "",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodySmall
//                     ?.copyWith(color: Theme.of(context).colorScheme.error),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
