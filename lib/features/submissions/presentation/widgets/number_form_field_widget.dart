import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';

class NumberFormFieldWidget extends StatefulWidget {
  final FieldEntity field;
  final num? value;
  final ValueChanged<num?> onChanged;

  const NumberFormFieldWidget({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
  });

  @override
  State<NumberFormFieldWidget> createState() => _NumberFormFieldWidgetState();
}

class _NumberFormFieldWidgetState extends State<NumberFormFieldWidget> {
  late final TextEditingController _controller;
  // bool _isUpdatingText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null ? widget.value.toString() : '',
    );
    _controller.addListener(() {
      // if (_isUpdatingText) return;
      final text = _controller.text.trim();
      widget.onChanged(num.tryParse(text));
    });
  }

  // @override
  // void didUpdateWidget(covariant NumberFormFieldWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.value != widget.value) {
  //     _isUpdatingText = true;
  //     _controller.text = widget.value?.toString() ?? '';
  //     _isUpdatingText = false;
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validator(String? value) {
    if (widget.field.required && (value == null || value.isEmpty)) {
      return '${widget.field.label} wajib diisi';
    }

    final numValue = num.tryParse(value ?? '');
    if (numValue == null) return 'Harus berupa angka';

    final min = widget.field.min;
    final max = widget.field.max;

    if (min != null && numValue < min) {
      return 'Minimal $min';
    }
    if (max != null && numValue > max) {
      return 'Maksimal $max';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
      label: widget.field.label,
      hint: widget.field.placeholder,
      controller: _controller,
      keyboardType: TextInputType.number,
      validator: _validator,
    );
  }
}
