import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/positions_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector.dart';
import 'package:workorder_company_app/shared/widgets/custom_dropdown.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_step_indicator.dart';
import 'package:workorder_company_app/shared/widgets/step_navigation_bar.dart.dart';

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

class _CreateNewFormPageState extends State<CreateNewFormPage>
    with TickerProviderStateMixin {
  late FormsBloc _formsBloc;
  late final PositionsBloc _positionsBloc;
  late final TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _fieldKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final List<EditableField> _fields = [];

  String _accessType = 'public';
  String _formType = 'work-order';
  final List<String> _accessibleBy = [];
  final List<PositionEntity> _allowedPositions = [];

  @override
  void initState() {
    super.initState();
    _formsBloc = sl<FormsBloc>();
    _positionsBloc = sl<PositionsBloc>()..add(GetPositionsRequested());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _positionsBloc.close();
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

  void _onNext(BuildContext context) {
    final currentIndex = _tabController.index;
    bool isValid = false;

    switch (currentIndex) {
      case 0:
        isValid = _formKey.currentState?.validate() ?? false;
        break;
      case 1:
    }

    if (isValid && currentIndex < _tabController.length - 1) {
      _tabController.animateTo(currentIndex + 1);
    }
  }

  void _onPrevious() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
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

  void _submitForm() {
    if (_fields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi Pertanyaan')),
      );
      return;
    }

    if (!(_fieldKey.currentState?.validate() ?? false)) {
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
            proxyDecorator: (child, index, animation) {
              return Material(
                color: Colors.transparent,
                elevation: 0,
                child: child,
              );
            },
            children: List.generate(field.options.length, (i) {
              final option = field.options[i];
              final controller = TextEditingController(text: option.value);
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );

              return Padding(
                key: ValueKey(option.key),
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    // 🔹 hanya icon ini yang bisa dipakai untuk drag
                    ReorderableDragStartListener(
                      index: i,
                      child: const Icon(Icons.drag_indicator_outlined),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomInputField(
                        label: 'Opsi ${i + 1}',
                        controller: controller,
                        onChanged: (val) {
                          field.options[i] =
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
                        color: Color.fromARGB(255, 255, 93, 81),
                      ),
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
                const Icon(Icons.drag_handle),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeField(index),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomInputField(
              label: "Pertanyaan",
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
            CustomDropdown<String>(
              label: "Tipe Pertanyaan",
              value: field.type,
              onChanged: (val) {
                if (val != null) setState(() => field.type = val);
              },
              items: const [
                DropdownMenuItem(value: 'text', child: Text('Text')),
                DropdownMenuItem(value: 'number', child: Text('Number')),
                DropdownMenuItem(value: 'textarea', child: Text('Textarea')),
                DropdownMenuItem(
                    value: 'single-select', child: Text('Single Select')),
                DropdownMenuItem(
                    value: 'multi-select', child: Text('Multi Select')),
              ],
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
            const Text('Tipe Akses',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Public')),
                    selected: _accessType == 'public',
                    onSelected: (_) => setState(() => _accessType = 'public'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Internal')),
                    selected: _accessType == 'internal',
                    onSelected: (_) => setState(() => _accessType = 'internal'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Dapat Diakses Oleh',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilterChip(
                    label: const Center(child: Text('Manager')),
                    selected: _accessibleBy.contains('manager'),
                    onSelected: (_) => _toggleAccessibleBy('manager'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChip(
                    label: const Center(child: Text('Staff')),
                    selected: _accessibleBy.contains('staff'),
                    onSelected: (_) => _toggleAccessibleBy('staff'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSetting() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Deskripsi wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Work order')),
                    selected: _formType == 'work-order',
                    onSelected: (_) => setState(() => _formType = 'work-order'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Report')),
                    selected: _formType == 'report',
                    onSelected: (_) => setState(() => _formType = 'report'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          proxyDecorator: (child, index, animation) {
            return Material(
              color: Colors.transparent,
              elevation: 0,
              child: child,
            );
          },
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
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildAllowedPositions() {
    return PositionsSelector(
      selectedPositions: _allowedPositions.toList(),
      onAdd: (pos) {
        setState(() {
          _allowedPositions.add(pos);
        });
      },
      onRemove: (pos) {
        setState(() {
          _allowedPositions.removeWhere((s) => s.id == pos.id);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _formsBloc),
        BlocProvider.value(value: _positionsBloc),
      ],
      child: BlocListener<FormsBloc, FormsState>(
        listener: (context, state) {
          if (state is FormsLoaded && !state.isSubLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form berhasil dibuat!')),
            );
          } else if (state is FormsError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Buat Form'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(72),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomStepIndicator(
                    currentStep: _tabController.index,
                    steps: const [
                      'Pengaturan Form',
                      'Pertanyaan',
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: StepNavigationBar(
              currentStep: _tabController.index,
              totalSteps: 2,
              onPrevious: _onPrevious,
              onNext: () => _onNext(context),
              finalAction: BlocSelector<FormsBloc, FormsState, bool>(
                selector: (state) =>
                    state is FormsLoaded ? state.isSubLoading : false,
                builder: (context, isLoading) {
                  return ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.upload),
                              SizedBox(width: 8),
                              Text('Simpan Form'),
                            ],
                          ),
                  );
                },
              ),
            ),
            // SafeArea(
            //   child: Padding(
            //     padding: const EdgeInsets.only(
            //         top: 2, left: 16, right: 16, bottom: 16),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         if (_tabController.index > 0)
            //           TextButton(
            //               onPressed: _onPrevious,
            //               child: Row(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Icon(Icons.arrow_back),
            //                   SizedBox(width: 6),
            //                   Text(
            //                     "Sebelumnya",
            //                   ),
            //                 ],
            //               )),
            //         Spacer(),
            //         _tabController.index == 1
            //             ? BlocSelector<FormsBloc, FormsState, bool>(
            //                 selector: (state) => state is FormsLoaded
            //                     ? state.isSubLoading
            //                     : false,
            //                 builder: (context, isLoading) {
            //                   return ElevatedButton(
            //                     onPressed: isLoading ? null : _submitForm,
            //                     style: ElevatedButton.styleFrom(
            //                       padding: const EdgeInsets.symmetric(
            //                           horizontal: 20, vertical: 12),
            //                     ),
            //                     child: isLoading
            //                         ? const SizedBox(
            //                             height: 18,
            //                             width: 18,
            //                             child: CircularProgressIndicator(
            //                                 strokeWidth: 2,
            //                                 color: Colors.white),
            //                           )
            //                         : Row(
            //                             mainAxisSize: MainAxisSize.min,
            //                             children: const [
            //                               Icon(Icons.upload),
            //                               SizedBox(width: 8),
            //                               Text('Simpan Form'),
            //                             ],
            //                           ),
            //                   );
            //                 },
            //               )
            //             : TextButton(
            //                 onPressed: () => _onNext(context),
            //                 child: Row(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     Text(
            //                       "Selanjutnya",
            //                     ),
            //                     SizedBox(width: 6),
            //                     Icon(Icons.arrow_forward),
            //                   ],
            //                 ),
            //               )
            //       ],
            //     ),
            //   ),
            // ),
            body: BlocBuilder<FormsBloc, FormsState>(
              buildWhen: (previous, current) {
                if (previous is FormsLoaded && current is FormsLoaded) {
                  return previous.isSubLoading != current.isSubLoading;
                }
                return previous.runtimeType != current.runtimeType;
              },
              builder: (context, state) {
                return TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Tab 1: Pengaturan Form
                    SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildFormSetting(),
                              _buildAccessControls(),
                              if (_accessibleBy.contains("staff"))
                                _buildAllowedPositions(),
                            ],
                          ),
                        )),

                    // Tab 2: Pertanyaan
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Form(
                            key: _fieldKey,
                            child: _buildFields(),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
