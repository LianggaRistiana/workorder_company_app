import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';

class ServiceSettingCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final ServiceAccessType accessType;
  final bool isActive;
  final ValueChanged<ServiceAccessType> onAccessTypeChanged;
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
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            label: "Judul Layanan",
            controller: titleController,
            // validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            validator: (value) => ValidatorUtils.required(value, fieldName: "Judul Layanan")
          ),
          const SizedBox(height: 12),
          CustomInputField(
            label: "Deskripsi",
            controller: descController,
            maxLines: 3,
            validator: (value) => ValidatorUtils.required(value, fieldName: "Deskripsi")
          ),
          const SizedBox(height: 12),
          const Text('Tipe Akses',
              style: TextStyle(fontWeight: FontWeight.bold)),

          // TODO : Change To enum selector
          Row(
            children: [
              for (final type in [
                ServiceAccessType.public,
                ServiceAccessType.internal,
                ServiceAccessType.memberOnly
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Center(child: Text(type.toString())),
                      selected: accessType == type,
                      onSelected: (_) => onAccessTypeChanged(type),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Status Layanan',
              style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}
