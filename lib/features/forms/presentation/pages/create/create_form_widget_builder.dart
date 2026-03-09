part of 'create_form_page.dart';

// ignore_for_file: invalid_use_of_protected_member
extension CreateFormWidgetBuilder on CreateFormPageState {
  Widget _buildOptionEditor(int fieldIndex) {
    final field = _fields[fieldIndex];
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Opsi Pilihan',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          // --- Reorderable List untuk options ---
          CustomList(
              isReorderable: true,
              emptyWidget: InformationBlock.warning(
                  "Setidaknya Pertanyaan memiliki 2 opsi"),
              items: field.options,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  field.options.reorder(oldIndex, newIndex);
                });
              },
              itemBuilder: (option, index) {
                final controller = TextEditingController(text: option.value);
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
                return Padding(
                  key: ValueKey(option.key),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.drag_indicator_outlined),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomInputField(
                          label: 'Opsi ${index + 1}',
                          controller: controller,
                          onChanged: (val) {
                            field.options[index] =
                                OptionEntity(key: option.key, value: val);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Opsi wajib diisi";
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline_rounded,
                        ),
                        onPressed: () => _removeOption(fieldIndex, index),
                      ),
                    ],
                  ),
                );
              }),
          const SizedBox(height: 8),
          DashedButton(
            title: 'Tambah Opsi',
            onTap: () => _addOption(fieldIndex),
            icon: Icons.add,
            color: Theme.of(context).colorScheme.primary,
            borderColor: Theme.of(context).disabledColor,
          ),
          
        ],
      ),
    );
  }

  Widget _buildFieldCard(int index) {
    final field = _fields[index];

    return CustomCard(
      key: ValueKey(field.order),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md),
      margin: const EdgeInsets.symmetric(vertical: 8),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              // const Icon(Icons.drag_handle),
              FieldTypeIcon(type: field.type),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _removeField(index),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomInputField(
            label: "Pertanyaan",
            maxLines: 3,
            onChanged: (value) => field.label = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Pertanyaan wajib diisi";
              }
              return null;
            },
            controller: TextEditingController(text: field.label),
          ),
          const SizedBox(height: 12),
          // CustomDropdown<String>(
          //   label: "Tipe Pertanyaan",
          //   value: field.type,
          //   onChanged: (val) {
          //     if (val != null) setState(() => field.type = val);
          //   },
          //   items: const [
          //     DropdownMenuItem(value: 'text', child: Text('Text')),
          //     DropdownMenuItem(value: 'number', child: Text('Number')),
          //     DropdownMenuItem(value: 'textarea', child: Text('Textarea')),
          //     DropdownMenuItem(
          //         value: 'single_select', child: Text('Single Select')),
          //     DropdownMenuItem(
          //         value: 'multi_select', child: Text('Multi Select')),
          //   ],
          // ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wajib diisi'),
                Switch(
                  value: field.required,
                  onChanged: (val) => setState(() => field.required = val),
                ),
              ],
            ),
          ),

          if (field.type == FieldType.number) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomInputField(
                    label: "Minimal",
                    keyboardType: TextInputType.number,
                    onChanged: (val) => field.min = int.tryParse(val),
                    controller: TextEditingController(
                        text: field.min?.toString() ?? ''),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomInputField(
                    label: "Maksimal",
                    keyboardType: TextInputType.number,
                    onChanged: (val) => field.max = int.tryParse(val),
                    controller: TextEditingController(
                        text: field.max?.toString() ?? ''),
                  ),
                ),
              ],
            ),
          ],
          if (field.type == FieldType.multiSelect ||
              field.type == FieldType.singleSelect)
            _buildOptionEditor(index),
        ],
      ),
    );
  }

  Widget _buildFormSetting() {
    return CustomCard(
      // elevation: 2,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            label: "Judul Form",
            controller: _titleController,
            hint: "Judul Sebagai langkah step pekerjaan",
            description:
                "Judul Form akan digunakan sebagai judul step di dalam report",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Judul wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          CustomInputField(
            label: "Deskripsi Form",
            controller: _descController,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Deskripsi wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          EnumSelector<FormType>(
              title: "Jenis Form",
              values: FormType.values,
              selectedValues: [_formType],
              isMultiSelect: false,
              onChanged: (type) => setState(
                  () => _formType = type.firstOrNull ?? FormType.workOrder))
        ],
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        CustomList(
            items: _fields,
            isReorderable: true,
            onReorder: (oldIndex, newIndex) => setState(() {
                  _fields.reorder(oldIndex, newIndex);
                }),
            itemBuilder: (_, index) => _buildFieldCard(index)),
        const SizedBox(height: 8),
        DashedButton(
          height: 150,
          borderRadius: 12,
          icon: Icons.add,
          onTap: _openFieldTypePicker,
          title: 'Tambah Pertanyaan',
          borderColor: Theme.of(context).disabledColor,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
