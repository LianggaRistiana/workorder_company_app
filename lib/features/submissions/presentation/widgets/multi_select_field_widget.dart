import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_filter_chip_option.dart';

class MultiSelectFormFieldWidget extends StatefulWidget {
  // final String label;
  // final List<OptionEntity> options;
  final FieldEntity field;
  final List<OptionEntity>? initialValue;
  final ValueChanged<List<OptionEntity>>? onChanged;

  const MultiSelectFormFieldWidget({
    super.key,
    required this.field,
    // required this.label,
    // required this.options,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<MultiSelectFormFieldWidget> createState() =>
      _MultiSelectFormFieldWidgetState();
}

class _MultiSelectFormFieldWidgetState
    extends State<MultiSelectFormFieldWidget> {
  late List<OptionEntity> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List<OptionEntity>.from(widget.initialValue ?? []);
  }

  void _handleSelectionChanged(List<OptionEntity> newSelected) {
    setState(() {
      _selectedValues = newSelected;
    });
    widget.onChanged?.call(newSelected);
  }

  @override
  Widget build(BuildContext context) {
    return CustomFilterChipOption(
        label: widget.field.label,
        options: widget.field.options ?? [],
        selectedValues: _selectedValues,
        singleSelect: false,
        onChanged: _handleSelectionChanged,
        validator: (_) {
          if (widget.field.required && (_selectedValues.isEmpty)) {
            return '${widget.field.label} wajib diisi';
          }
          return null;
        });
  }
}
