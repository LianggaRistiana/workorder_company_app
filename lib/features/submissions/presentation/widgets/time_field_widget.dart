import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/item_tile_lined.dart';

// TODO : Test this Time Field Widget
class TimeFieldWidget extends FormField<DateTime> {
  TimeFieldWidget({
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
            return _TimeFieldContent(
              field: field,
              value: fieldState.value,
              errorText: fieldState.errorText,
              onChanged: (dateTime) {
                fieldState.didChange(dateTime);
                onChanged(dateTime);
              },
            );
          },
        );
}

class _TimeFieldContent extends StatelessWidget {
  final FieldEntity field;
  final DateTime? value;
  final String? errorText;
  final ValueChanged<DateTime> onChanged;

  const _TimeFieldContent({
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
  });

  bool get hasError => errorText?.isNotEmpty ?? false;

  TimeOfDay? get selectedTime {
    if (value == null) return null;

    return TimeOfDay.fromDateTime(value!);
  }

  String _timeText(BuildContext context) {
    final time = selectedTime;

    if (time == null) return 'Pilih Waktu';

    return time.format(context);
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked == null) return;

    final current = value ?? DateTime.now();

    final result = DateTime(
      current.year,
      current.month,
      current.day,
      picked.hour,
      picked.minute,
    );

    onChanged(result);
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
          onTap: () => _pickTime(context),
          child: ItemTileLined(
            lineColor: hasError ? errorColor : null,
            child: Text(
              _timeText(context),
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

// class TimeFieldWidget extends StatefulWidget {
//   final FieldEntity field;
//   final DateTime? value;
//   final ValueChanged<DateTime> onChanged;

//   const TimeFieldWidget({
//     super.key,
//     required this.field,
//     this.value,
//     required this.onChanged,
//   });

//   @override
//   State<TimeFieldWidget> createState() => _TimeFieldWidgetState();
// }

// class _TimeFieldWidgetState extends State<TimeFieldWidget> {
//   TimeOfDay? initialTime;

//   TimeOfDay? get populatedTime {
//     final value = widget.value;

//     if (value == null) return null;

//     return TimeOfDay.fromDateTime(value);
//   }

//   @override
//   void initState() {
//     initialTime = populatedTime;
//     super.initState();
//   }

//   Future<void> _pickTime(
//     BuildContext context,
//     ValueChanged<TimeOfDay> didChange,
//   ) async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: initialTime ?? TimeOfDay.now(),
//     );

//     if (picked != null) {
//       final current = widget.value ?? DateTime.now();

//       final result = DateTime(
//         current.year,
//         current.month,
//         current.day,
//         picked.hour,
//         picked.minute,
//       );
//       setState(() {
//         initialTime = picked;
//       });
//       didChange(picked);
//       widget.onChanged(result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FormField<TimeOfDay>(
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       initialValue: initialTime,
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
//                 child: Text(initialTime?.format(context) ?? 'Pilih Waktu',
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
