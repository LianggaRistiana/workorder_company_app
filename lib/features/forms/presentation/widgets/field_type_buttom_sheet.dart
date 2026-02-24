import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/field_type_icon.dart';

class FieldTypeBottomSheet extends StatelessWidget {
  final FieldType? selectedType;
  final ValueChanged<FieldType> onSelected;

  const FieldTypeBottomSheet({
    super.key,
    required this.onSelected,
    this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Text(
              "Pilih Jenis Field",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 16),

            ...FieldType.values.map((type) {
              final isSelected = type == selectedType;

              return ListTile(
                title: FieldTypeIcon(type: type),
                trailing: isSelected
                    ? Icon(Icons.check,
                        color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onSelected(type);
                },
              );
            }),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
