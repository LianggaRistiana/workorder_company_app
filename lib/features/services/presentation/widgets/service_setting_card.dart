import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';

class ServiceSettingCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final String accessType;
  final bool isActive;
  final ValueChanged<String> onAccessTypeChanged;
  final ValueChanged<bool> onStatusChanged;

  const ServiceSettingCard({
    super.key,
    required this.titleController,
    required this.descController,
    required this.accessType,
    required this.isActive,
    required this.onAccessTypeChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              label: "Judul Service",
              controller: titleController,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            CustomInputField(
              label: "Deskripsi Service",
              controller: descController,
              maxLines: 3,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            const Text('Tipe Akses', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                for (final type in ['public', 'member-only', 'internal'])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Center(child: Text(type)),
                        selected: accessType == type,
                        onSelected: (_) => onAccessTypeChanged(type),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Status Layanan', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Aktif')),
                    selected: isActive,
                    onSelected: (_) => onStatusChanged(true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Tidak aktif')),
                    selected: !isActive,
                    onSelected: (_) => onStatusChanged(false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
