import 'package:flutter/material.dart';

class CustomFilterChip<T> extends StatelessWidget {
  final String label;
  final String? description;
  final List<T> options;
  final List<T> selectedValues;
  final void Function(List<T>)? onChanged;
  final bool enabled;
  final bool singleSelect;
  final String? Function(List<T>?)? validator;
  final String? errorText;
  final String Function(T)? labelBuilder;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValues,
    this.onChanged,
    this.description,
    this.enabled = true,
    this.singleSelect = false,
    this.validator,
    this.errorText,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      initialValue: selectedValues,
      validator: validator,
      builder: (fieldState) {
        final hasError = (fieldState.errorText?.isNotEmpty ?? false) ||
            (errorText?.isNotEmpty ?? false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Column(
              children: options.map((option) {
                final isSelected = selectedValues.contains(option);
                return SizedBox(
                  width: double.infinity, // full width
                  child: FilterChip(
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(labelBuilder != null
                          ? labelBuilder!(option)
                          : option.toString()),
                    ),
                    selected: isSelected,
                    onSelected: enabled
                        ? (selected) {
                            final newSelected = List<T>.from(selectedValues);
                            if (singleSelect) {
                              if (isSelected && selected) {
                                newSelected.clear();
                              } else {
                                newSelected.clear();
                                if (selected) newSelected.add(option);
                              }
                            } else {
                              if (selected) {
                                if (!newSelected.contains(option)) {
                                  newSelected.add(option);
                                }
                              } else {
                                newSelected.remove(option);
                              }
                            }

                            fieldState.didChange(newSelected);
                            if (onChanged != null) onChanged!(newSelected);
                          }
                        : null,
                    selectedColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    disabledColor: Colors.grey[200],
                  ),
                );
              }).toList(),
            ),
            if (!hasError && description != null && description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  errorText ?? fieldState.errorText ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        );
      },
    );
  }
}
