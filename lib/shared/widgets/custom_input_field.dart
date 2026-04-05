import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';

class CustomInputField extends StatefulWidget {
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
  final Color backgroundColor;
  final TextInputAction? textInputAction;

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
    this.textInputAction,
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isError = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    errorText = widget.errorText;
  }

  Color _getIconColor(BuildContext context) {
    if (!widget.enabled) return Theme.of(context).disabledColor;
    if (_isError) return Theme.of(context).colorScheme.error;
    if (_isFocused) return Theme.of(context).colorScheme.primary;
    return Colors.grey[600]!;
  }

  @override
  void didUpdateWidget(covariant CustomInputField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.errorText != widget.errorText) {
      setState(() {
        errorText = widget.errorText;
        _isError = widget.errorText != null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getIconColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          focusNode: _focusNode,
          textInputAction: TextInputAction.next,
          onEditingComplete: widget.onEditingComplete,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onChanged: (value) {
            if (_isError || errorText != null) {
              setState(() {
                _isError = false;
                errorText = null;
              });
            }
            widget.onChanged?.call(value);
          },
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          validator: (val) {
            final result = widget.validator?.call(val);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isError = result != null || errorText != null;
                });
              }
            });
            if (errorText != null) {
              return errorText;
            }
            return result;
          },
          decoration: InputDecoration(
            labelText: widget.label,
            floatingLabelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorText: errorText,
            prefixIcon: widget.prefixIcon != null
                ? IconTheme(
                    data: IconThemeData(color: iconColor),
                    child: widget.prefixIcon!,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconTheme(
                    data: IconThemeData(color: iconColor),
                    child: widget.suffixIcon!,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.inputField),
            ),
            filled: true,
            fillColor: widget.enabled
                ? widget.backgroundColor
                : Theme.of(context).disabledColor.withAlpha(1),
          ),
        ),
        if ((!_isError &&
                (widget.errorText == null || widget.errorText!.isEmpty)) &&
            widget.description != null &&
            widget.description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              widget.description!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }
}
