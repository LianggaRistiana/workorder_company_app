import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/field_option_item.dart';

class FormFieldCard extends StatelessWidget {
  final dynamic field;
  const FormFieldCard({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    field.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    field.type,
                    style: const TextStyle(
                        color: Colors.blueAccent, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  field.required
                      ? Icons.warning_amber_rounded
                      : Icons.info_outline_rounded,
                  color: field.required ? Colors.lightBlue : Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  field.required ? "Wajib diisi" : "Opsional",
                  style: TextStyle(
                      color: field.required ? Colors.lightBlue : Colors.grey),
                ),
              ],
            ),
            if (field.min != null || field.max != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Range nilai: ${field.min ?? '-'} - ${field.max ?? '-'}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            if ((field.options ?? []).isNotEmpty) ...[
              const Divider(height: 20),
              const Text(
                'Opsi:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: field.options!.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) =>
                    FieldOptionItem(value: field.options![index].value),
              ),
            ],
          ],
        ),
      ),
    );
  }
}