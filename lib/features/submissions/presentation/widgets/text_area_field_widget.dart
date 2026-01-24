import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';

class TextAreaFieldWidget extends StatefulWidget {
  final FieldEntity field;
  final String? value;
  final ValueChanged<String> onChanged;

  const TextAreaFieldWidget({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
  });

  @override
  State<TextAreaFieldWidget> createState() => _TextAreaFieldWidgetState();
}

class _TextAreaFieldWidgetState extends State<TextAreaFieldWidget> {
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
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        validator: (value) {
          if (widget.field.required && (value == null || value.isEmpty)) {
            return '${widget.field.label} wajib diisi';
          }
          return null;
        });
  }
}
