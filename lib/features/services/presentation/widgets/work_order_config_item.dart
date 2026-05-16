import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/authorization/rule/position_permission_rule/position_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector_container.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector_container.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_work_order_config_draft.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/desider_approval_lock.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/item_tile_lined.dart';

class WorkOrderConfigItem extends StatefulWidget {
  final WorkOrderDraftingType draftingType;

  final ServiceWorkOrderConfigDraft draft;
  final void Function(FormEntity value) onWorkOrderFormChanged;

  final ValueChanged<PositionEntity> onDepartmentUpdate;

  final ValueChanged<int?> onMinChange;
  final ValueChanged<int?> onMaxChange;
  final ValueChanged<WorkOrderAprrovalAccess> onApprovalChange;
  final VoidCallback? onRemove;

  const WorkOrderConfigItem({
    super.key,
    required this.draftingType,
    required this.onWorkOrderFormChanged,
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

    if (oldWidget.draft != widget.draft) {
      return;
    }

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
    final workOrderForm = draft.workOrderForm;
    final isManualDrafting =
        widget.draftingType == WorkOrderDraftingType.manual;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBox.small(
                icon: Icons.assignment_turned_in_outlined,
              ),
              const SizedBox(width: 12),
              if (workOrderForm != null && isManualDrafting) ...[
                Expanded(
                  child: Text(
                    workOrderForm.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else if (workOrderForm == null && isManualDrafting) ...[
                FormsSelectorContainer(
                  selectedForms: [],
                  onAdd: widget.onWorkOrderFormChanged,
                  buttonBuilder: (context, onPressed, isLoading) => Expanded(
                    child: DashedButton(
                      title: "Pilih Formulir Perintah Kerja",
                      onTap: onPressed,
                      borderColor: Theme.of(context).disabledColor,
                      color: Theme.of(context).colorScheme.primary,
                      icon: Icons.add,
                      borderRadius: 16,
                      isLoading: isLoading,
                    ),
                  ),
                )
              ] else ...[
                Spacer()
              ],
              if (widget.onRemove != null)
                IconButton.filled(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.error, // warna icon
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          /// Approval Access
          ConditionalApprovalSection(
            type: widget.draftingType,
            child: EnumSelector(
              title: "Akses Persetujuan",
              isMultiSelect: false,
              labelBuilder: (val) => val.displayName,
              values: WorkOrderAprrovalAccess.values,
              selectedValues: [draft.workOrderApprovalAccess],
              onChanged: (values) {
                if (values.isNotEmpty) {
                  widget.onApprovalChange(values.first);
                }
              },
            ),
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
              if (draft.departmentOnDuty != null) {
                return ClickableCustomCard(
                    margin: EdgeInsets.all(0),
                    onTap: onPressed,
                    child: ItemTileLined(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          draft.departmentOnDuty!.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ));
              }

              return DashedButton(
                title: "Pilih Department",
                onTap: onPressed,
                borderColor: Theme.of(context).disabledColor,
                color: Theme.of(context).colorScheme.primary,
                icon: Icons.add,
                height: 60,
                borderRadius: 12,
                isLoading: isLoading,
              );
            },
          ).require(hasNoPosition(),
              fallback: draft.departmentOnDuty != null
                  ? ItemTileLined(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          draft.departmentOnDuty!.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    )
                  : null),

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
                  validator: (value) {
                    return ValidatorUtils.validate(
                      value,
                      fieldName: "",
                      minValue: 0,
                      [
                        ValidatorType.required,
                        ValidatorType.number,
                        ValidatorType.minValue,
                      ],
                    );
                  },
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
                  validator: (value) {
                    return ValidatorUtils.validate(
                      value,
                      fieldName: "",
                      minValue: widget.draft.minStaff?.toDouble() ?? 0,
                      [
                        ValidatorType.required,
                        ValidatorType.number,
                        ValidatorType.minValue,
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
