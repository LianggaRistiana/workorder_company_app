import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

import '../../domain/entities/service_entity.dart';
import '../../domain/entities/form_order_entity.dart';
import '../../domain/entities/required_staff_entity.dart';
import '../bloc/services_bloc.dart';
import '../../../forms/domain/entities/form_entity.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({super.key});

  @override
  State<CreateServicePage> createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  late final ServicesBloc _servicesBloc;

  List<RequiredStaffEntity> requiredStaff = [];
  List<FormOrderEntity> selectedWorkOrderForms = [];
  List<FormOrderEntity> selectedReportForms = [];
  String accessType = 'Public';
  bool isActive = true;

  // Dummy positions
  final dummyPositions = const [
    PositionEntity(id: '650f1d3c2f1b2c7f2d555555', name: 'HR'),
    PositionEntity(id: '650f1d3c2f1b2c7f2d444444', name: 'Supervisor'),
    PositionEntity(id: '650f1d3c2f1b2c7f2d777777', name: 'sales'),
  ];

  // Dummy forms
  final dummyForms = const [
    FormEntity(
      id: 'f001',
      title: 'Form Pemeriksaan Awal',
      description:
          'Digunakan untuk memeriksa kondisi awal sebelum pekerjaan dimulai.',
      accessType: 'internal',
      accessibleBy: ['technician', 'supervisor'],
    ),
    FormEntity(
      id: 'f002',
      title: 'Form Laporan Harian',
      description:
          'Berisi catatan kegiatan harian selama pekerjaan berlangsung.',
      accessType: 'internal',
      accessibleBy: ['technician'],
    ),
    FormEntity(
      id: 'f003',
      title: 'Form Evaluasi Akhir',
      description:
          'Digunakan untuk mengevaluasi hasil pekerjaan setelah selesai.',
      accessType: 'admin',
      accessibleBy: ['manager'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _servicesBloc = sl<ServicesBloc>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _servicesBloc.close();
    super.dispose();
  }

  /// Bottom sheet untuk memilih posisi
  void _showPositionBottomSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          Text('Choose Position',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...dummyPositions.map((pos) {
            final alreadyAdded =
                requiredStaff.any((r) => r.position.id == pos.id);

            return ListTile(
              title: Text(pos.name),
              trailing: alreadyAdded
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                if (!alreadyAdded) {
                  setState(() {
                    requiredStaff.add(
                      RequiredStaffEntity(
                        position: pos,
                        minimumStaff: 1,
                        maximumStaff: 1,
                      ),
                    );
                  });
                }
                Navigator.pop(sheetContext);
              },
            );
          }),
        ],
      ),
    );
  }

  /// Bottom sheet untuk memilih form (tanpa urutan, hanya pilih)
  void _showFormBottomSheet({
    required String title,
    required List<FormEntity> items,
    required List<FormOrderEntity> targetList,
  }) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...items.map((form) {
            final alreadyAdded = targetList.any((f) => f.form.id == form.id);

            return ListTile(
              title: Text(form.title),
              subtitle: Text(form.description),
              trailing: alreadyAdded
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.add_circle_outline),
              onTap: () {
                setState(() {
                  if (!alreadyAdded) {
                    targetList.add(
                      FormOrderEntity(
                        order: targetList.length + 1,
                        form: form,
                      ),
                    );
                  } else {
                    targetList.removeWhere((f) => f.form.id == form.id);
                    // Reassign order setelah penghapusan
                    for (var i = 0; i < targetList.length; i++) {
                      targetList[i] =
                          targetList[i].copyWith(order: i + 1);
                    }
                  }
                });
                Navigator.pop(sheetContext);
              },
            );
          }),
        ],
      ),
    );
  }

  bool _validateRequiredStaff() {
    for (final staff in requiredStaff) {
      if (staff.minimumStaff > staff.maximumStaff) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Minimum staff can\'t be greater than maximum for ${staff.position.name}'),
          ),
        );
        return false;
      }
    }
    return true;
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateRequiredStaff()) return;

    final service = ServiceEntity(
      id: '',
      title: _titleController.text,
      description: _descController.text,
      requiredStaff: requiredStaff,
      workOrderForms: selectedWorkOrderForms,
      reportForms: selectedReportForms,
      accessType: accessType,
      isActive: isActive,
    );

    _servicesBloc.add(CreateServiceRequested(service));
  }

  Widget _buildFormList(String label, List<FormOrderEntity> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: () => _showFormBottomSheet(
                title: label,
                items: dummyForms,
                targetList: list,
              ),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        if (list.isEmpty)
          const Text('No forms selected',
              style: TextStyle(color: Colors.grey))
        else
          Column(
            children: list.map((f) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text('${f.order}. ${f.form.title}'),
                  subtitle: Text(f.form.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      setState(() {
                        list.remove(f);
                        // Reorder ulang setelah delete
                        for (var i = 0; i < list.length; i++) {
                          list[i] = list[i].copyWith(order: i + 1);
                        }
                      });
                    },
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _servicesBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create New Service')),
        body: BlocListener<ServicesBloc, ServicesState>(
          listener: (context, state) {
            if (state is ServicesLoaded && (state.isSubLoading == false)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Service created successfully')),
              );
              context.pop();
            } else if (state is ServicesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration:
                        const InputDecoration(labelText: 'Service Title'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descController,
                    decoration:
                        const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // === Required Staff ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Required Staff',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: _showPositionBottomSheet,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  if (requiredStaff.isEmpty)
                    const Text('No staff added',
                        style: TextStyle(color: Colors.grey))
                  else
                    Column(
                      children: requiredStaff.map((s) {
                        final minController = TextEditingController(
                            text: s.minimumStaff.toString());
                        final maxController = TextEditingController(
                            text: s.maximumStaff.toString());

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    s.position.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: minController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                        labelText: 'Min', isDense: true),
                                    onChanged: (val) {
                                      final parsed = int.tryParse(val);
                                      if (parsed != null) {
                                        setState(() {
                                          final index =
                                              requiredStaff.indexOf(s);
                                          requiredStaff[index] =
                                              s.copyWith(minimumStaff: parsed);
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: maxController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                        labelText: 'Max', isDense: true),
                                    onChanged: (val) {
                                      final parsed = int.tryParse(val);
                                      if (parsed != null) {
                                        setState(() {
                                          final index =
                                              requiredStaff.indexOf(s);
                                          requiredStaff[index] =
                                              s.copyWith(maximumStaff: parsed);
                                        });
                                      }
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    setState(() => requiredStaff.remove(s));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const Divider(height: 32),

                  // === Work Order Forms ===
                  _buildFormList('Work Order Forms', selectedWorkOrderForms),
                  const Divider(height: 32),

                  // === Report Forms ===
                  _buildFormList('Report Forms', selectedReportForms),
                  const Divider(height: 32),

                  DropdownButtonFormField<String>(
                    value: accessType,
                    decoration: const InputDecoration(labelText: 'Access Type'),
                    items: const [
                      DropdownMenuItem(value: 'Public', child: Text('Public')),
                      DropdownMenuItem(
                          value: 'Private', child: Text('Private')),
                    ],
                    onChanged: (val) =>
                        setState(() => accessType = val ?? 'Public'),
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: const Text('Active'),
                    value: isActive,
                    onChanged: (val) => setState(() => isActive = val),
                  ),
                  const SizedBox(height: 24),

                  BlocBuilder<ServicesBloc, ServicesState>(
                    builder: (context, state) {
                      final isLoading = (state is ServicesLoading) ||
                          (state is ServicesLoaded &&
                              (state.isSubLoading ?? false));

                      return ElevatedButton(
                        onPressed: isLoading ? null : _onSubmit,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
