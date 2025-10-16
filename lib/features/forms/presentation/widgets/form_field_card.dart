import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/field_option_item.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/field_type_chip.dart';

class FormFieldCard extends StatelessWidget {
  final FieldEntity field;
  const FormFieldCard({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return CustomCard(
      elevation: 1.5,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// === Header: Field label + type chip ===
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(field.label, style: textTheme.titleMedium),
              ),
              FieldTypeChip(type: field.type),
            ],
          ),

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
            // const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300, height: 20),
            CustomList<OptionEntity>(
                separatorHeight: 6,
                isReorderable: false,
                items: field.options!,
                itemBuilder: (option, index) =>
                    // Text(field.options![index].value)
                    FieldOptionItem(value: option.value)),
            Divider(color: Colors.grey.shade300, height: 20),
          ],

          /// === Info: required or optional ===
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                field.required
                    ? Icons.warning_amber_rounded
                    : Icons.info_outline_rounded,
                color:
                    field.required ? colorScheme.primary : Colors.grey.shade500,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                field.required ? "Wajib diisi" : "Opsional",
                style: textTheme.bodyMedium?.copyWith(
                  color: field.required
                      ? colorScheme.primary
                      : Colors.grey.shade600,
                  fontWeight:
                      field.required ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
