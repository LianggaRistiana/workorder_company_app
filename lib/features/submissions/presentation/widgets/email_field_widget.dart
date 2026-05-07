import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';

class EmailFieldWidget extends StatefulWidget {
  final FieldEntity field;
  final String? value;
  final ValueChanged<String> onChanged;

  const EmailFieldWidget({
    super.key,
    required this.field,
    this.value,
    required this.onChanged,
  });

  @override
  State<EmailFieldWidget> createState() => _EmailFieldWidgetState();
}

class _EmailFieldWidgetState extends State<EmailFieldWidget> {
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
          return ValidatorUtils.validate(
            value,
            [
              if (widget.field.required) ValidatorType.required,
              ValidatorType.email,
            ],
            fieldName: widget.field.label,
          );
        });
  }
}
