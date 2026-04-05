import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';

class CustomFilterChipOption extends StatelessWidget {
  final String label;
  final String? description;
  final List<OptionEntity> options;
  final List<OptionEntity> selectedValues;
  final void Function(List<OptionEntity>)? onChanged;
  final bool enabled;
  final bool singleSelect;
  final String? Function(List<OptionEntity>?)? validator;
  final String? errorText;
  final String Function(OptionEntity)? labelBuilder;
  final bool required;

  const CustomFilterChipOption({
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
    this.required = false,
  });

  bool _isSelected(List<OptionEntity> selected, OptionEntity option) {
    return selected.any((s) => s.key == option.key);
  }

  List<OptionEntity> _addIfNotExists(
      List<OptionEntity> list, OptionEntity option) {
    if (list.any((s) => s.key == option.key)) return list;
    return [...list, option];
  }

  List<OptionEntity> _removeIfExists(
      List<OptionEntity> list, OptionEntity option) {
    return list.where((s) => s.key != option.key).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<OptionEntity>>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: List<OptionEntity>.from(selectedValues),
      validator: validator,
      builder: (fieldState) {
        final hasError = (fieldState.errorText?.isNotEmpty ?? false) ||
            (errorText?.isNotEmpty ?? false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: hasError
                    ? Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error)
                    : Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Column(
              children: options.map((option) {
                final isSelected = _isSelected(selectedValues, option);
                return SizedBox(
                  width: double.infinity,
                  child: FilterChip(
                    side: hasError
                        ? BorderSide(
                            color: Theme.of(context).colorScheme.error,
                            // width: 1.5,
                          )
                        : null,
                    label: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        labelBuilder != null
                            ? labelBuilder!(option)
                            : option.value,
                        style: hasError
                            ? TextStyle(
                                color: Theme.of(context).colorScheme.error)
                            : null,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: enabled
                        ? (selected) {
                            // create new selected list based on key equality
                            List<OptionEntity> newSelected =
                                List<OptionEntity>.from(selectedValues);

                            if (singleSelect) {
                              if (selected) {
                                newSelected = [option];
                              } else {
                                newSelected = [];
                              }
                            } else {
                              if (selected) {
                                newSelected =
                                    _addIfNotExists(newSelected, option);
                              } else {
                                newSelected =
                                    _removeIfExists(newSelected, option);
                              }
                            }

                            fieldState.didChange(newSelected);
                            if (onChanged != null) onChanged!(newSelected);
                          }
                        : null,
                    selectedColor:
                        Theme.of(context).colorScheme.primary.withAlpha(12),
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
