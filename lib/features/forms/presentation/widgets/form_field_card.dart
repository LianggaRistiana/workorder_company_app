import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/field_option_item.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/field_type_icon.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';

class FormFieldCard extends StatelessWidget {
  final FieldEntity field;

  const FormFieldCard({
    super.key,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldTypeIcon(type: field.type),
          const SizedBox(height: 12),
          _FieldMainContent(field: field),
          _FieldRangeInfo(field: field),
          _FieldOptionsSection(field: field),
          const SizedBox(height: 8),
          _FieldRequiredInfo(field: field),
        ],
      ),
    );
  }
}

class _FieldMainContent extends StatelessWidget {
  final FieldEntity field;

  const _FieldMainContent({required this.field});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label, style: theme.textTheme.titleSmall),
            if (field.placeholder != null) ...[
              const SizedBox(height: 8),
              Text(
                field.placeholder!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FieldRangeInfo extends StatelessWidget {
  final FieldEntity field;

  const _FieldRangeInfo({required this.field});

  @override
  Widget build(BuildContext context) {
    if (field.min == null && field.max == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer.withAlpha(80),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.straighten_rounded,
                size: 18,
                color: theme.colorScheme.primary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Range nilai: ${field.min ?? '-'} - ${field.max ?? '-'}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// OPTIMIZE : add feature Toggle to see all option to reduce render time
class _FieldOptionsSection extends StatelessWidget {
  final FieldEntity field;

  const _FieldOptionsSection({required this.field});

  @override
  Widget build(BuildContext context) {
    final options = field.options ?? [];
    if (options.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text("Opsi", style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        CustomList<OptionEntity>(
          separatorHeight: 6,
          items: options,
          emptyWidget: const SizedBox.shrink(),
          itemBuilder: (option, index) => FieldOptionItem(value: option.value),
        ),
      ],
    );
  }
}

class _FieldRequiredInfo extends StatelessWidget {
  final FieldEntity field;

  const _FieldRequiredInfo({required this.field});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRequired = field.required;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isRequired
                ? Icons.warning_amber_outlined
                : Icons.info_outline_rounded,
            color:
                isRequired ? theme.colorScheme.primary : Colors.grey.shade500,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            isRequired ? "Wajib diisi" : "Opsional",
            style: theme.textTheme.labelSmall?.copyWith(
              color: isRequired
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontWeight: isRequired ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
