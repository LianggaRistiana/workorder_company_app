import 'package:flutter/material.dart';

class EnumSelector<T extends Enum> extends StatelessWidget {
  final String title;
  final List<T> values;
  final List<T> selectedValues;
  final void Function(List<T>) onChanged;
  final String Function(T)? labelBuilder;
  final bool isMultiSelect;

  const EnumSelector({
    super.key,
    required this.title,
    required this.values,
    required this.selectedValues,
    required this.onChanged,
    this.labelBuilder,
    this.isMultiSelect = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 2),
        Column(
          children: values.map((value) {
            final isSelected = selectedValues.contains(value);
            final label = labelBuilder?.call(value) ?? value.name;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: SizedBox(
                width: double.infinity, // chip memenuhi lebar
                child: FilterChip(
                  padding: EdgeInsets.all(12),
                  label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(label)),
                  // label: Text(label),
                  selected: isSelected,
                  onSelected: (selected) {
                    List<T> updatedValues;
                    if (isMultiSelect) {
                      updatedValues = selected
                          ? {...selectedValues, value}.toList()
                          : selectedValues.where((v) => v != value).toList();
                    } else {
                      updatedValues = selected ? [value] : [];
                    }

                    onChanged(updatedValues);
                  },
                  // selectedColor: Theme.of(context).colorScheme.primary.withAlpha(20),
                  checkmarkColor: Theme.of(context).colorScheme.primary,
                  backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                  labelStyle: Theme.of(context).chipTheme.labelStyle,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}


// import 'package:flutter/material.dart';

// class EnumSelector<T extends Enum> extends StatelessWidget {
//   final String title;
//   final List<T> values;
//   final List<T> selectedValues;
//   final void Function(List<T>) onChanged;
//   final String Function(T)? labelBuilder;
//   final bool isMultiSelect;

//   // Tambahkan Form Field seperti Drop down
//   const EnumSelector({
//     super.key,
//     required this.title,
//     required this.values,
//     required this.selectedValues,
//     required this.onChanged,
//     this.labelBuilder,
//     this.isMultiSelect = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: theme.textTheme.titleSmall,
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: values.map((value) {
//             final isSelected = selectedValues.contains(value);
//             final label = labelBuilder?.call(value) ?? value.toString();

//             return FilterChip(
//               label: Text(label),
//               selected: isSelected,
//               onSelected: (selected) {
//                 List<T> updatedValues;
//                 if (isMultiSelect) {
//                   updatedValues = selected
//                       ? {...selectedValues, value}.toList()
//                       : selectedValues.where((v) => v != value).toList();
//                 } else {
//                   updatedValues = selected ? [value] : selectedValues;
//                 }

//                 onChanged(updatedValues);
//               },
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
