import 'package:flutter/material.dart';

class EnumSelector<T extends Enum> extends StatelessWidget {
  final String title;
  final List<T> values;
  final List<T> selectedValues;
  final void Function(List<T>) onChanged;
  final String Function(T)? labelBuilder;
  final bool isMultiSelect;

  // Tambahkan Form Field seperti Drop down
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
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map((value) {
            final isSelected = selectedValues.contains(value);
            final label = labelBuilder?.call(value) ?? value.toString();

            return FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                List<T> updatedValues;
                // if (isMultiSelect) {
                //   updatedValues = selected
                //       ? [...selectedValues, value]
                //       : selectedValues.where((v) => v != value).toList();
                // } else {
                //   updatedValues = selected ? [value] : [];
                // }
                if (isMultiSelect) {
                  updatedValues = selected
                      ? {...selectedValues, value}.toList()
                      : selectedValues.where((v) => v != value).toList();
                } else {
                  updatedValues = selected ? [value] : selectedValues;
                }

                onChanged(updatedValues);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
