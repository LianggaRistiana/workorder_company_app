import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_filter_chip_option.dart';

class SingleSelectFormFieldWidget extends StatefulWidget {
  // final String label;
  // final List<OptionEntity> options;
  final OptionEntity? initialValue;
  final FieldEntity field;
  final ValueChanged<OptionEntity?>? onChanged;

  const SingleSelectFormFieldWidget({
    super.key,
    required this.field,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<SingleSelectFormFieldWidget> createState() =>
      _SingleSelectFormFieldWidgetState();
}

class _SingleSelectFormFieldWidgetState
    extends State<SingleSelectFormFieldWidget> {
  OptionEntity? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  void _handleSelectionChanged(List<OptionEntity> selected) {
    setState(() {
      _selectedValue = selected.isNotEmpty ? selected.first : null;
    });
    widget.onChanged?.call(_selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return CustomFilterChipOption(
        label: widget.field.label,
        options: widget.field.options ?? [],
        selectedValues: _selectedValue != null ? [_selectedValue!] : [],
        singleSelect: true,
        onChanged: _handleSelectionChanged,
        validator: (_) {
          if (widget.field.required && (_selectedValue == null)) {
            return '${widget.field.label} wajib diisi';
          }
          return null;
        });
  }
}
