import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector_container.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_work_order_config_draft.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/work_order_config_item.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class ServiceWorkOrderFormTabView extends StatelessWidget {
  final List<ServiceWorkOrderConfigDraft> workOrders;

  final void Function(int index, PositionEntity position)
      onDepartmentUpdate;

  final void Function(int index, int? value) onMinChange;
  final void Function(int index, int? value) onMaxChange;
  final void Function(int index, WorkOrderAprrovalAccess value)
      onApprovalChange;

  final void Function(int index) onRemove;
  final ValueChanged onAdd;

  const ServiceWorkOrderFormTabView({
    super.key,
    required this.workOrders,
    required this.onDepartmentUpdate,
    required this.onMinChange,
    required this.onMaxChange,
    required this.onApprovalChange,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          CustomList(
            scrollable: false,
            emptyWidget: InformationBlock.warning(
              "Layanan setidaknya memiliki satu perintah kerja",
            ),
            items: workOrders,
            itemBuilder: (_, index) {
              final draft = workOrders[index];

              return WorkOrderConfigItem(
                key: ValueKey(index),
                draft: draft,
                onDepartmentUpdate: (position) =>
                    onDepartmentUpdate(index, position),
                onMinChange: (value) =>
                    onMinChange(index, value),
                onMaxChange: (value) =>
                    onMaxChange(index, value),
                onApprovalChange: (value) =>
                    onApprovalChange(index, value),
                onRemove: () => onRemove(index),
              );
            },
          ),

          const SizedBox(height: 12),

          FormsSelectorContainer(
            selectedForms: [],
            onAdd: onAdd,
            buttonBuilder: (context, onPressed, isLoading) => DashedButton(
              title: "Tambah Perintah Kerja",
              onTap: onPressed,
              borderColor: Theme.of(context).disabledColor,
              color: Theme.of(context).colorScheme.primary,
              icon: Icons.add,
              height: 120,
              borderRadius: 16,
              isLoading: isLoading,
            ),
          )
        ],
      ),
    );
  }
}