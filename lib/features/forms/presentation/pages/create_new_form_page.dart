import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';

class CreateNewFormPage extends StatefulWidget {
  const CreateNewFormPage({super.key});

  @override
  State<CreateNewFormPage> createState() => _CreateNewFormPageState();
}

class EditableField {
  String label;
  String type;
  bool required;
  int? min;
  int? max;
  List<OptionEntity> options;
  int order;

  EditableField({
    this.label = '',
    this.type = 'text',
    this.required = false,
    this.min,
    this.max,
    this.order = 1,
    List<OptionEntity>? options,
  }) : options = options ?? [];

  FieldEntity toEntity() => FieldEntity(
        label: label,
        type: type,
        required: required,
        min: min,
        max: max,
        options: options,
        order: order,
      );
}

class _CreateNewFormPageState extends State<CreateNewFormPage> {
  late FormsBloc _formsBloc;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final List<EditableField> _fields = [];

  String _accessType = 'public';
  final List<String> _accessibleBy = [];
  final List<PositionEntity> _allowedPositions = [];

  final List<PositionEntity> _positionOptions = const [
    PositionEntity(id: '1', name: 'Manager'),
    PositionEntity(id: '2', name: 'Supervisor'),
    PositionEntity(id: '3', name: 'Staff'),
    PositionEntity(id: '4', name: 'Technician'),
  ];

  @override
  void initState() {
    super.initState();
    _formsBloc = sl<FormsBloc>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addField() {
    setState(() {
      _fields.add(EditableField(order: _fields.length + 1));
    });
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
      for (int i = 0; i < _fields.length; i++) {
        _fields[i].order = i + 1;
      }
    });
  }

  void _addOption(int fieldIndex) {
    setState(() {
      _fields[fieldIndex].options.add(
            OptionEntity(
              key: '${DateTime.now().millisecondsSinceEpoch}',
              value: '',
            ),
          );
    });
  }

  void _removeOption(int fieldIndex, int optionIndex) {
    setState(() => _fields[fieldIndex].options.removeAt(optionIndex));
  }

  void _toggleAccessibleBy(String role) {
    setState(() {
      if (_accessibleBy.contains(role)) {
        _accessibleBy.remove(role);
      } else {
        _accessibleBy.add(role);
      }
      if (!_accessibleBy.contains('staff')) {
        _allowedPositions.clear();
      }
    });
  }

  void _toggleAllowedPosition(PositionEntity position) {
    setState(() {
      final exists = _allowedPositions.any((p) => p.id == position.id);
      if (exists) {
        _allowedPositions.removeWhere((p) => p.id == position.id);
      } else {
        _allowedPositions.add(position);
      }
    });
  }

  void _submitForm() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong')),
      );
      return;
    }

    final form = FormEntity(
      id: '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      accessType: _accessType,
      accessibleBy: _accessibleBy,
      allowedPositions: _allowedPositions,
      fields: _fields.map((e) => e.toEntity()).toList(),
    );

    // Tambahkan aksi Bloc di sini
    _formsBloc.add(CreateFormRequested(form));
  }

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
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = field.options.removeAt(oldIndex);
                field.options.insert(newIndex, item);
              });
            },
            children: List.generate(field.options.length, (i) {
              final option = field.options[i];
              final controller = TextEditingController(text: option.value);
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));

              return Padding(
                key: ValueKey(option.key),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.drag_handle),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Opsi ${i + 1}',
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (val) {
                          field.options[i] =
                              OptionEntity(key: option.key, value: val);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeOption(fieldIndex, i),
                    ),
                  ],
                ),
              );
            }),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addOption(fieldIndex),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Opsi'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldCard(int index) {
    final field = _fields[index];

    return Card(
      key: ValueKey(field.order),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text("Field ${field.order}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const Spacer(),
                const Icon(Icons.drag_handle),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeField(index),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // TextField(
            //   decoration: const InputDecoration(
            //     labelText: 'Label Field',
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: (val) => field.label = val,
            //   controller: TextEditingController(text: field.label),
            // ),
            CustomInputField(
              label: "Label Field",
              onChanged: (value) => field.label = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Label wajib diisi";
                }
                return null;
              },
              controller: TextEditingController(text: field.label),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: field.type,
              decoration: const InputDecoration(
                labelText: 'Tipe Field',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'text', child: Text('Text')),
                DropdownMenuItem(value: 'number', child: Text('Number')),
                DropdownMenuItem(value: 'textarea', child: Text('Textarea')),
                DropdownMenuItem(
                    value: 'single-select', child: Text('Single Select')),
                DropdownMenuItem(
                    value: 'multi-select', child: Text('Multi Select')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => field.type = val);
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Wajib diisi'),
                Switch(
                  value: field.required,
                  onChanged: (val) => setState(() => field.required = val),
                ),
              ],
            ),
            if (field.type == 'number') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Min Value',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => field.min = int.tryParse(val),
                      controller: TextEditingController(
                          text: field.min?.toString() ?? ''),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Max Value',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => field.max = int.tryParse(val),
                      controller: TextEditingController(
                          text: field.max?.toString() ?? ''),
                    ),
                  ),
                ],
              ),
            ],
            if (field.type.contains('select')) _buildOptionEditor(index),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessControls() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pengaturan Akses',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _accessType,
              decoration: const InputDecoration(
                labelText: 'Tipe Akses',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'public', child: Text('Public')),
                DropdownMenuItem(
                    value: 'member-only', child: Text('Member Only')),
                DropdownMenuItem(value: 'internal', child: Text('Internal')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _accessType = val);
              },
            ),
            const SizedBox(height: 16),
            const Text('Dapat Diakses Oleh:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('Manager'),
                  selected: _accessibleBy.contains('manager'),
                  onSelected: (_) => _toggleAccessibleBy('manager'),
                ),
                FilterChip(
                  label: const Text('Staff'),
                  selected: _accessibleBy.contains('staff'),
                  onSelected: (_) => _toggleAccessibleBy('staff'),
                ),
              ],
            ),
            if (_accessibleBy.contains('staff')) ...[
              const SizedBox(height: 16),
              const Text('Posisi yang Diizinkan:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _positionOptions.map((pos) {
                  final selected = _allowedPositions.any((p) => p.id == pos.id);
                  return FilterChip(
                    label: Text(pos.name),
                    selected: selected,
                    onSelected: (_) => _toggleAllowedPosition(pos),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _formsBloc,
      child: BlocListener<FormsBloc, FormsState>(
        listener: (context, state) {
          if (state is FormsLoaded && !state.isSubLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Form berhasil dibuat!')));
          } else if (state is FormsError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Buat Form Baru')),
          body: BlocBuilder<FormsBloc, FormsState>(
            builder: (context, state) {
              final isLoading =
                  state is FormsLoaded ? state.isSubLoading : false;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomInputField(
                      label: "Judul Form",
                      controller: _titleController,
                      hint: "Masukan nama lengkap",
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
                    ),
                    const SizedBox(height: 16),
                    _buildAccessControls(),

                    // --- Reorderable List untuk fields ---
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex--;
                          final item = _fields.removeAt(oldIndex);
                          _fields.insert(newIndex, item);
                          for (int i = 0; i < _fields.length; i++) {
                            _fields[i].order = i + 1;
                          }
                        });
                      },
                      children: List.generate(
                        _fields.length,
                        (index) => _buildFieldCard(index),
                      ),
                    ),

                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _addField,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Field'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Simpan Form',
                              style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
