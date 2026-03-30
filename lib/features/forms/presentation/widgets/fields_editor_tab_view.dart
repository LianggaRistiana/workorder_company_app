import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/forms/presentation/coordinator/form_editor_coordinator.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/reorderable_custom_list.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';

class FieldsEditorTabView extends StatelessWidget {
  final FormEditorCoordinator coordinator;
  final VoidCallback onAddField;
  final GlobalKey<FormState>? formKey;

  const FieldsEditorTabView({
    super.key,
    required this.coordinator,
    required this.onAddField,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final fields = coordinator.draft.fields;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            ReorderableCustomList(
              items: fields,
              emptyWidget: InformationBlock.warning("Pertanyaan kosong"),
              onReorder: coordinator.moveField,
              itemBuilder: (_, index) => FieldCardWidget(
                key: ValueKey(fields[index].uiKey),
                index: index,
                coordinator: coordinator,
              ),
            ),
            const SizedBox(height: 8),
            DashedButton(
              height: 150,
              borderRadius: 12,
              icon: Icons.add,
              onTap: onAddField,
              title: 'Tambah Pertanyaan',
              borderColor: Theme.of(context).disabledColor,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 32),
          ],
        ),
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
          /// Label
          CustomInputField(
            label: "Pertanyaan",
            controller: _labelController,
            onChanged: (value) =>
                widget.coordinator.updateFieldLabel(widget.index, value),
            validator: (value) {
              return ValidatorUtils.single(
                value,
                fieldName: "Pertanyaan Tidak Boleh Kosong",
                ValidatorType.required,
              );
            },
          ),

          /// Placeholder
          CustomInputField(
            label: "Placeholder",
            controller: _placeholderController,
            onChanged: (value) =>
                widget.coordinator.updateFieldPlaceholder(widget.index, value),
          ),

          /// Required
          Switch(
            value: field.required,
            onChanged: (val) =>
                widget.coordinator.updateFieldRequired(widget.index, val),
          ),

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
                        fieldName: "Minimal Tidak Boleh Kosong",
                        ValidatorType.required,
                      );
                    },
                  ),
                ),
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
                        fieldName: "Maksimal Tidak Boleh Kosong",
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
          isReorderable: true,
          // onReorder: (oldIndex, newIndex) {
          //   widget.coordinator.moveOption(
          //     widget.fieldIndex,
          //     oldIndex,
          //     newIndex,
          //   );
          // },
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
                  icon: const Icon(Icons.delete),
                )
              ],
            );
          },
        ),
        DashedButton(
          title: "Tambah Opsi",
          onTap: () => widget.coordinator.addOption(widget.fieldIndex),
        )
      ],
    );
  }
}
