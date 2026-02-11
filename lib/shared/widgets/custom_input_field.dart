import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? description;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final String? errorText;
  final int? maxLines;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;



  const CustomInputField({
    super.key,
    required this.label,
    this.hint,
    this.description,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.maxLines = 1,
    this.onEditingComplete,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.inputField),
            ),
            filled: true,
            fillColor: enabled
                ? Colors.transparent
                : Theme.of(context).disabledColor.withValues(alpha: 0.1),
          ),
        ),
        if ((errorText == null || errorText!.isEmpty) && description != null && description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              description!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }
}
