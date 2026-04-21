import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_order_enum.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_color_mapper.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_icon_mapper.dart';

class WorkOrderStatusSelector extends StatelessWidget {
  final List<WorkOrderStatus> values;
  final List<WorkOrderStatus> selectedValues;
  final void Function(List<WorkOrderStatus>) onChanged;

  const WorkOrderStatusSelector({
    super.key,
    required this.values,
    required this.selectedValues,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedSet = selectedValues.toSet();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final status = values[index];
        final isSelected = selectedSet.contains(status);

        final iconColor = isSelected ? status.color : theme.disabledColor;

        return InkWell(
          onTap: () {
            final updated = isSelected
                ? selectedValues.where((e) => e != status).toList()
                : [...selectedValues, status];

            onChanged(updated);
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? status.color.withAlpha(15)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? status.color : theme.disabledColor,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  status.icon,
                  color: iconColor,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  status.displayName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? status.color : theme.disabledColor,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
