import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final String? description;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final bool enabled;
  final String? Function(T?)? validator;
  final String? errorText;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.description,
    this.enabled = true,
    this.validator,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      validator: validator,
      builder: (fieldState) {
        final hasError = (fieldState.errorText != null &&
                fieldState.errorText!.isNotEmpty) ||
            (errorText != null && errorText!.isNotEmpty);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                isDense: true,
                hintText: hint,
                errorText: errorText ?? fieldState.errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.inputField),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.inputField),
                    borderSide: BorderSide(width: 2)),
                fillColor: enabled
                    ? Colors.transparent
                    : Theme.of(context).disabledColor.withAlpha(1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isExpanded: true,
                  value: value,
                  items: items,
                  onChanged: enabled
                      ? (val) {
                          fieldState.didChange(val);
                          if (onChanged != null) onChanged!(val);
                        }
                      : null,
                ),
                // child: DropdownButton1<String>(
                //   value: selectedValue,
                //   items: items
                //       .map((item) => DropdownMenuItem(
                //             value: item,
                //             child: Text(item),
                //           ))
                //       .toList(),
                //   onChanged: (val) {
                //     setState(() => selectedValue = val);
                //   },
                //   dropdownDecoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(16),
                //     color: Colors.white, // warna menu
                //   ),
                // ),
              ),
            ),
            if (!hasError && description != null && description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
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
      },
    );
  }
}
