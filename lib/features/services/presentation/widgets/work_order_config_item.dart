import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector_container.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/service_config_state.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class WorkOrderConfigItem extends StatefulWidget {
  final ServiceWorkOrderConfigDraft draft;
  final ValueChanged<PositionEntity> onDepartmentUpdate;
  final ValueChanged<int?> onMinChange;
  final ValueChanged<int?> onMaxChange;
  final ValueChanged<WorkOrderAprrovalAccess> onApprovalChange;
  final VoidCallback? onRemove;

  const WorkOrderConfigItem({
    super.key,
    required this.draft,
    required this.onDepartmentUpdate,
    required this.onMinChange,
    required this.onMaxChange,
    required this.onApprovalChange,
    this.onRemove,
  });

  @override
  State<WorkOrderConfigItem> createState() => _WorkOrderConfigItemState();
}

class _WorkOrderConfigItemState extends State<WorkOrderConfigItem> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();

    _minController = TextEditingController(
      text: widget.draft.minStaff?.toString() ?? '',
    );

    _maxController = TextEditingController(
      text: widget.draft.maxStaff?.toString() ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant WorkOrderConfigItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller only jika value berubah dari luar
    if (oldWidget.draft.minStaff != widget.draft.minStaff) {
      _minController.text = widget.draft.minStaff?.toString() ?? '';
    }

    if (oldWidget.draft.maxStaff != widget.draft.maxStaff) {
      _maxController.text = widget.draft.maxStaff?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    debugPrint("🔥 Rebuild WorkOrderConfigItem ${widget.draft.workOrderForm.title}");

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              const IconBox(icon: Icons.assignment_turned_in_outlined),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  draft.workOrderForm.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (widget.onRemove != null)
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),

          const SizedBox(height: 16),

          /// Approval Access
          EnumSelector(
            title: "Akses Persetujuan",
            isMultiSelect: false,
            values: WorkOrderAprrovalAccess.values,
            selectedValues: [draft.workOrderApprovalAccess],
            onChanged: (values) {
              if (values.isNotEmpty) {
                widget.onApprovalChange(values.first);
              }
            },
          ),

          const SizedBox(height: 20),

          /// Department
          Text(
            "Department bertugas",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),

          PositionsSelectorContainer(
            selectedPositions:
                draft.departmentOnDuty != null ? [draft.departmentOnDuty!] : [],
            onAdd: widget.onDepartmentUpdate,
            buttonBuilder: (context, onPressed, isLoading) {
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (draft.departmentOnDuty != null) {
                return ClickableCustomCard(
                  margin: EdgeInsets.all(0),
                  onTap: onPressed,
                  child: Row(
                    children: [
                      const IconBox(icon: Icons.badge_outlined, paddingSize: 8, iconSize: 20,),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          draft.departmentOnDuty!.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      )
                    ],
                  ),
                );
              }

              return DashedButton(
                title: "Pilih Department",
                onTap: onPressed,
                borderColor: Theme.of(context).disabledColor,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.add,
                height: 60,
                borderRadius: 12,
              );
            },
          ),

          const SizedBox(height: 20),

          /// Staff Count
          Text(
            "Jumlah Pegawai diperlukan",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: CustomInputField(
                  label: "Min",
                  controller: _minController,
                  keyboardType: TextInputType.number,
                  onChanged: (p0) => widget.onMinChange(
                    int.tryParse(p0),
                  ),
                  // onEditingComplete: () {
                  //   widget.onMinChange(
                  //     int.tryParse(_minController.text),
                  //   );
                  //   // FocusScope.of(context).unfocus();
                  // },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomInputField(
                  label: "Max",
                  controller: _maxController,
                  keyboardType: TextInputType.number,
                  onChanged: (p0) => widget.onMaxChange(
                    int.tryParse(p0),
                  ),
                  // onEditingComplete: () {
                  //   widget.onMaxChange(
                  //     int.tryParse(_maxController.text),
                  //   );
                  //   // FocusScope.of(context).unfocus();
                  // },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
