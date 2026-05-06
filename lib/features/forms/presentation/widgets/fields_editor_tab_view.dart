import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/forms/presentation/coordinator/form_editor_coordinator.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/field_type_icon.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/reorderable_custom_list.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
 
class FieldsEditorTabView extends StatelessWidget {
  final FormEditorCoordinator coordinator;
  final VoidCallback onAddField;

  const FieldsEditorTabView({
    super.key,
    required this.coordinator,
    required this.onAddField,
  });

  @override
  Widget build(BuildContext context) {
    final fields = coordinator.draft.fields;

    return ReorderableCustomList(
      padding: const EdgeInsets.all(16),
      items: fields,
      emptyWidget: InformationBlock.warning("Pertanyaan kosong"),
      onReorder: coordinator.moveField,
      footer: DashedButton(
        height: 150,
        borderRadius: 12,
        icon: Icons.add,
        onTap: onAddField,
        title: 'Tambah Pertanyaan',
        borderColor: Theme.of(context).disabledColor,
        color: Theme.of(context).colorScheme.primary,
      ),
      itemBuilder: (item, index) => FieldCardWidget(
        key: ValueKey(item.uiKey),
        index: index,
        coordinator: coordinator,
      ),
    );
  }
}

class FieldCardWidget extends StatefulWidget {
  final int index;
  final FormEditorCoordinator coordinator;

  const FieldCardWidget({
    super.key,
    required this.index,
    required this.coordinator,
  });

  @override
  State<FieldCardWidget> createState() => _FieldCardWidgetState();
}

class _FieldCardWidgetState extends State<FieldCardWidget> {
  late TextEditingController _labelController;
  late TextEditingController _placeholderController;
  late TextEditingController _minController;
  late TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    final field = widget.coordinator.draft.fields[widget.index];

    _labelController = TextEditingController(text: field.label);

    _placeholderController = TextEditingController(text: field.placeholder);

    _minController = TextEditingController(text: field.min?.toString() ?? '');

    _maxController = TextEditingController(text: field.max?.toString() ?? '');
  }

  @override
  void dispose() {
    _labelController.dispose();
    _placeholderController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.coordinator.draft.fields[widget.index];

    return CustomCard(
      child: Column(
        children: [
          Row(
            children: [
              // const Icon(Icons.drag_handle),
              FieldTypeIcon(type: field.type),
              const Spacer(),
              IconButton(
                icon: const Icon(AppIcon.delete),
                onPressed: () => widget.coordinator.removeField(widget.index),
              ),
            ],
          ),

          /// Label
          CustomInputField(
            label: "Pertanyaan",
            controller: _labelController,
            maxLines: 2,
            onChanged: (value) =>
                widget.coordinator.updateFieldLabel(widget.index, value),
            validator: (value) {
              return ValidatorUtils.single(
                value,
                fieldName: "Pertanyaan",
                ValidatorType.required,
              );
            },
          ),
          const SizedBox(height: 8),

          /// Placeholder
          CustomInputField(
            label: "Placeholder",
            maxLines: 2,
            controller: _placeholderController,
            onChanged: (value) =>
                widget.coordinator.updateFieldPlaceholder(widget.index, value),
          ),
          const SizedBox(height: 12),

          /// Required
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wajib diisi'),
                Switch(
                  value: field.required,
                  onChanged: (val) =>
                      widget.coordinator.updateFieldRequired(widget.index, val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (field.type == FieldType.number)
            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    label: "Minimal",
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => widget.coordinator.updateFieldMin(
                      widget.index,
                      int.tryParse(val) ?? 0,
                    ),
                    validator: (value) {
                      return ValidatorUtils.single(
                        value,
                        fieldName: "Minimal",
                        ValidatorType.required,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // FIXME[Medium] : validator min max
                Expanded(
                  child: CustomInputField(
                    label: "Maksimal",
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => widget.coordinator.updateFieldMax(
                      widget.index,
                      int.tryParse(val) ?? 0,
                    ),
                    validator: (value) {
                      return ValidatorUtils.single(
                        value,
                        fieldName: "Maksimal",
                        ValidatorType.required,
                      );
                    },
                  ),
                ),
              ],
            ),

          if (field.type == FieldType.multiSelect ||
              field.type == FieldType.singleSelect)
            OptionEditorWidget(
              fieldIndex: widget.index,
              coordinator: widget.coordinator,
            ),
        ],
      ),
    );
  }
}

class OptionEditorWidget extends StatefulWidget {
  final int fieldIndex;
  final FormEditorCoordinator coordinator;

  const OptionEditorWidget({
    super.key,
    required this.fieldIndex,
    required this.coordinator,
  });

  @override
  State<OptionEditorWidget> createState() => _OptionEditorWidgetState();
}

class _OptionEditorWidgetState extends State<OptionEditorWidget> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.coordinator.draft.fields[widget.fieldIndex];

    return Column(
      children: [
        CustomList(
          items: field.options,
          emptyWidget: InformationBlock.warning("Opsi Kosong"),
          separatorHeight: 6,
          itemBuilder: (option, index) {
            _controllers.putIfAbsent(
              option.key,
              () => TextEditingController(text: option.value),
            );

            return Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    label: 'Opsi ${index + 1}',
                    controller: _controllers[option.key]!,
                    validator: (value) {
                      return ValidatorUtils.single(
                        value,
                        fieldName: "Opsi",
                        ValidatorType.required,
                      );
                    },
                    onChanged: (val) => widget.coordinator.updateOptionValue(
                      widget.fieldIndex,
                      option.key,
                      val,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _controllers[option.key]?.dispose();
                    _controllers.remove(option.key);

                    widget.coordinator.removeOption(
                      widget.fieldIndex,
                      option.key,
                    );
                  },
                  icon: const Icon(AppIcon.remove),
                )
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        DashedButton(
          title: "Tambah Opsi",
          color: Theme.of(context).colorScheme.primary,
          borderColor: Theme.of(context).disabledColor,
          icon: Icons.add,
          onTap: () => widget.coordinator.addOption(widget.fieldIndex),
        )
      ],
    );
  }
}
