import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class CreateNewFormPage extends StatefulWidget {
  const CreateNewFormPage({super.key});

  @override
  State<CreateNewFormPage> createState() => _CreateNewFormPageState();
}

/// Wrapper UI — bukan domain entity
class EditableField {
  String label;
  String type;
  bool required;
  int? min;
  int? max;
  List<OptionEntity> options;

  EditableField({
    this.label = '',
    this.type = 'text',
    this.required = false,
    this.min,
    this.max,
    List<OptionEntity>? options,
  }) : options = options ?? [];

  FieldEntity toEntity() => FieldEntity(
        label: label,
        type: type,
        required: required,
        min: min,
        max: max,
        options: options,
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

  void _addField() => setState(() => _fields.add(EditableField()));
  void _removeField(int index) => setState(() => _fields.removeAt(index));

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

    _formsBloc.add(CreateFormRequested(form));
  }

  Widget _buildOptionEditor(int fieldIndex) {
    final field = _fields[fieldIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Opsi Pilihan:'),
        const SizedBox(height: 4),
        ...List.generate(field.options.length, (i) {
          final option = field.options[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Opsi ${i + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setState(() {
                        field.options[i] = OptionEntity(
                          key: option.key,
                          value: val,
                        );
                      });
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
        TextButton.icon(
          onPressed: () => _addOption(fieldIndex),
          icon: const Icon(Icons.add),
          label: const Text('Tambah Opsi'),
        ),
      ],
    );
  }

  Widget _buildFieldCard(int index) {
    final field = _fields[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Label Field',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => field.label = val),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
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
                      onChanged: (val) {
                        setState(() => field.min = int.tryParse(val));
                      },
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
                      onChanged: (val) {
                        setState(() => field.max = int.tryParse(val));
                      },
                    ),
                  ),
                ],
              ),
            ],
            if (field.type.contains('select')) _buildOptionEditor(index),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeField(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _accessType,
          decoration: const InputDecoration(
            labelText: 'Tipe Akses',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'public', child: Text('Public')),
            DropdownMenuItem(value: 'member-only', child: Text('Member Only')),
            DropdownMenuItem(value: 'internal', child: Text('Internal')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _accessType = val);
          },
        ),
        const SizedBox(height: 16),
        const Text('Dapat Diakses Oleh:',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
        const SizedBox(height: 12),
        if (_accessibleBy.contains('staff')) ...[
          const Text('Posisi yang Diizinkan untuk Staff:',
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
              const SnackBar(content: Text('Form berhasil dibuat!')),
            );
            // Navigator.pop(context);
          } else if (state is FormsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
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
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Form',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildAccessControls(),
                    const SizedBox(height: 16),
                    ...List.generate(_fields.length, _buildFieldCard),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _addField,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Field'),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Simpan Form'),
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
