import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/field_option_item.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';

class FormFieldCard extends StatelessWidget {
  final FieldEntity field;
  const FormFieldCard({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return CustomCard(
      // elevation: 1.5,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// === Header: Field label + type chip ===
          // FieldTypeIcon(type: field.type),
          // const SizedBox(height: 12),
          // Text(
          //   "Pertanyaan",
          //   style: Theme.of(context).textTheme.titleSmall,
          // ),
          Text(field.label,
              style: textTheme.titleSmall),
          const SizedBox(height: 12),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const SizedBox(width: 36),
          //     Expanded(
          //       child: Text(field.label,
          //           style: textTheme.bodyMedium?.copyWith(
          //             fontStyle: FontStyle.italic,
          //           )),
          //     ),
          //   ],
          // ),
          if (field.placeholder != null) ...[
            // const SizedBox(height: 16),
            // Text(
            //   "Petunjuk",
            //   style: Theme.of(context).textTheme.titleSmall,
            // ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 36),
                Expanded(
                  child: Text(field.label,
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      )),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          /// === Range info (if any) ===
          if (field.min != null || field.max != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainer
                    .withAlpha(80),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.straighten_rounded,
                    size: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Range nilai: ${field.min ?? '-'} - ${field.max ?? '-'}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          /// === Options list (for select fields) ===
          if ((field.options ?? []).isNotEmpty) ...[
            Text("Opsi", style: textTheme.titleSmall),
            const SizedBox(height: 8),
            // Divider(color: Colors.grey.shade300, height: 20),
            CustomList<OptionEntity>(
                separatorHeight: 6,
                isReorderable: false,
                items: field.options!,
                itemBuilder: (option, index) =>
                    // Text(field.options![index].value)
                    FieldOptionItem(value: option.value)),
            // Divider(color: Colors.grey.shade300, height: 20),
          ],

          /// === Info: required or optional ===
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.surfaceContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  field.required
                      ? Icons.warning_amber_outlined
                      : Icons.info_outline_rounded,
                  color: field.required
                      ? colorScheme.primary
                      : Colors.grey.shade500,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  field.required ? "Wajib diisi" : "Opsional",
                  style: textTheme.labelSmall?.copyWith(
                    color: field.required
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight:
                        field.required ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
