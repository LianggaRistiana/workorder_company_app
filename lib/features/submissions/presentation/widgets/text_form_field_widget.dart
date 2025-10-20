import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';

class TextFormFieldWidget extends StatefulWidget {
  final FieldEntity field;
  final String? value;
  final ValueChanged<String> onChanged;

  const TextFormFieldWidget({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputField(
        label: widget.field.label,
        hint: widget.field.placeholder,
        controller: _controller,
        validator: (value) {
          if (widget.field.required && (value == null || value.isEmpty)) {
            return '${widget.field.label} wajib diisi';
          }
          return null;
        });
  }
}
