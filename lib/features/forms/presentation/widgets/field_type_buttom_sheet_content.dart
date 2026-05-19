import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/field_type_icon.dart';

class FieldTypeBottomSheetContent extends StatelessWidget {
  final FieldType? selectedType;
  final ValueChanged<FieldType> onSelected;

  const FieldTypeBottomSheetContent({
    super.key,
    required this.onSelected,
    this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Pilih Jenis Pertanyaan",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...FieldType.availableType.map((type) {
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
