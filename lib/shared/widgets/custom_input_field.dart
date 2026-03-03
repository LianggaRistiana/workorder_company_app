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
    this.backgroundColor = Colors.transparent,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  Color _getIconColor(BuildContext context) {
    if (!widget.enabled) return Theme.of(context).disabledColor;
    if (_isError) return Theme.of(context).colorScheme.error;
    if (_isFocused) return Theme.of(context).colorScheme.primary;
    return Colors.grey[600]!;
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getIconColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          focusNode: _focusNode,
          onEditingComplete: widget.onEditingComplete,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          validator: (val) {
            final result = widget.validator?.call(val);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isError = result != null;
                });
              }
            });
            return result;
          },
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            errorText: widget.errorText,
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


// import 'package:flutter/material.dart';
// import 'package:workorder_company_app/core/theme/app_radius.dart';

// class CustomInputField extends StatelessWidget {
//   final String label;
//   final String? hint;
//   final String? description;
//   final TextEditingController? controller;
//   final TextInputType keyboardType;
//   final bool obscureText;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final String? Function(String?)? validator;
//   final void Function(String)? onChanged;
//   final bool enabled;
//   final String? errorText;
//   final int? maxLines;
//   final VoidCallback? onEditingComplete;
//   final FocusNode? focusNode;



//   const CustomInputField({
//     super.key,
//     required this.label,
//     this.hint,
//     this.description,
//     this.controller,
//     this.keyboardType = TextInputType.text,
//     this.obscureText = false,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.validator,
//     this.onChanged,
//     this.enabled = true,
//     this.errorText,
//     this.maxLines = 1,
//     this.onEditingComplete,
//     this.focusNode,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           focusNode: focusNode,
//           onEditingComplete: onEditingComplete,
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           controller: controller,
//           keyboardType: keyboardType,
//           obscureText: obscureText,
//           validator: validator,
//           onChanged: onChanged,
//           enabled: enabled,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             labelText: label,
//             hintText: hint,
//             hintStyle: TextStyle(color: Colors.grey[400]),
//             errorText: errorText,
//             prefixIcon: prefixIcon,
//             suffixIcon: suffixIcon,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(AppRadius.inputField),
//             ),
//             filled: true,
//             fillColor: enabled
//                 ? Colors.transparent
//                 : Theme.of(context).disabledColor.withValues(alpha: 0.1),
//           ),
//         ),
//         if ((errorText == null || errorText!.isEmpty) && description != null && description!.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(top: 4, left: 12),
//             child: Text(
//               description!,
//               style: Theme.of(context)
//                   .textTheme
//                   .bodySmall
//                   ?.copyWith(color: Colors.grey[600]),
//             ),
//           ),
//       ],
//     );
//   }
// }
