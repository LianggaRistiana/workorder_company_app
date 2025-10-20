import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_filter_chip_option.dart';

class SingleSelectFormFieldWidget extends StatelessWidget {
  final String label;
  final List<OptionEntity> options;
  final OptionEntity? value;
  final ValueChanged<OptionEntity?> onChanged;

  const SingleSelectFormFieldWidget({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFilterChipOption(
      label: label,
      options: options,
      selectedValues: value != null ? [value!] : [],
      singleSelect: true,
      onChanged: (selected) {
        onChanged(selected.isNotEmpty ? selected.first : null);
      },
    );
  }
}
