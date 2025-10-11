import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/form_order_entity.dart';
import '../../domain/entities/required_staff_entity.dart';
import '../bloc/services_bloc.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({super.key});

  @override
  State<CreateServicePage> createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final _serviceKey = GlobalKey<FormState>();
  final _woKey = GlobalKey<FormState>();
  final _reportKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  late final ServicesBloc _servicesBloc;
  late final FormsBloc _formsBloc;

  List<RequiredStaffEntity> requiredStaff = [];
  List<FormOrderEntity> selectedWorkOrderForms = [];
  List<FormOrderEntity> selectedReportForms = [];
  String accessType = 'public';
  bool isActive = true;

  // Dummy positions
  final dummyPositions = const [
    PositionEntity(id: '650f1d3c2f1b2c7f2d555555', name: 'HR'),
    PositionEntity(id: '650f1d3c2f1b2c7f2d444444', name: 'Supervisor'),
    PositionEntity(id: '650f1d3c2f1b2c7f2d777777', name: 'sales'),
  ];

  @override
  void initState() {
    super.initState();
    _servicesBloc = sl<ServicesBloc>();
    _formsBloc = sl<FormsBloc>()..add(GetFormsRequested());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _servicesBloc.close();
    _formsBloc.close();
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
    // final isServiceValid = _serviceKey.currentState?.validate() ?? false;
    // final isWOValid = _woKey.currentState?.validate() ?? false;
    // final isReportValid = _reportKey.currentState?.validate() ?? false;

    // if (!isServiceValid || !isWOValid || !isReportValid) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Mohon lengkapi semua form!')),
    //   );
    //   return;
    // }
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

  Widget _buildServiceSetting() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              label: "Judul Service",
              controller: _titleController,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            CustomInputField(
              label: "Deskripsi Service",
              controller: _descController,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            const Text('Tipe Akses',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Public')),
                    selected: accessType == 'public',
                    onSelected: (_) => setState(() => accessType = 'public'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Member')),
                    selected: accessType == 'member-only',
                    onSelected: (_) =>
                        setState(() => accessType = 'member-only'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Internal')),
                    selected: accessType == 'internal',
                    onSelected: (_) => setState(() => accessType = 'internal'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active'),
              value: isActive,
              onChanged: (val) => setState(() => isActive = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionsRequiredSetting() {
    return Column(
      children: [
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
          const Text('No staff added', style: TextStyle(color: Colors.grey))
        else
          Column(
            children: requiredStaff.map((s) {
              final minController =
                  TextEditingController(text: s.minimumStaff.toString());
              final maxController =
                  TextEditingController(text: s.maximumStaff.toString());

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          s.position.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
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
                                final index = requiredStaff.indexOf(s);
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
                                final index = requiredStaff.indexOf(s);
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _servicesBloc),
        BlocProvider.value(value: _formsBloc),
      ],
      child: BlocListener<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is ServicesLoaded && !state.isSubLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Service berhasil dibuat!')),
            );
          } else if (state is ServicesError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Buat Service Baru'),
              bottom: const TabBar(
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: 'Pengaturan Service'),
                  Tab(text: 'Form WO'),
                  Tab(text: 'Form Laporan'),
                ],
              ),
              actions: [
                BlocSelector<ServicesBloc, ServicesState, bool>(
                  selector: (state) =>
                      state is ServicesLoaded ? state.isSubLoading : false,
                  builder: (context, isLoading) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: TextButton.icon(
                        onPressed: isLoading ? null : _onSubmit,
                        icon: isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: const Text('Simpan Service'),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: BlocBuilder<ServicesBloc, ServicesState>(
              buildWhen: (previous, current) {
                if (previous is ServicesLoaded && current is ServicesLoaded) {
                  return previous.isSubLoading != current.isSubLoading;
                }
                return previous.runtimeType != current.runtimeType;
              },
              builder: (context, state) {
                return TabBarView(
                  children: [
// Tab 1
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _serviceKey,
                        child: Column(
                          children: [
                            _buildServiceSetting(),
                            _buildPositionsRequiredSetting(),
                          ],
                        ),
                      ),
                    ),
                    // Tab 2 (Form WO)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          FormsSelector(
                            key: _woKey,
                            selectedFormsOrder: selectedWorkOrderForms,
                            onAdd: (formOrder) {
                              setState(
                                  () => selectedWorkOrderForms.add(formOrder));
                            },
                            onRemove: (formOrder) {
                              setState(() {
                                selectedWorkOrderForms.remove(formOrder);
                                for (var i = 0;
                                    i < selectedWorkOrderForms.length;
                                    i++) {
                                  selectedWorkOrderForms[i] =
                                      selectedWorkOrderForms[i]
                                          .copyWith(order: i + 1);
                                }
                              });
                            },
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) newIndex -= 1;
                                final item =
                                    selectedWorkOrderForms.removeAt(oldIndex);
                                selectedWorkOrderForms.insert(newIndex, item);
                                for (var i = 0;
                                    i < selectedWorkOrderForms.length;
                                    i++) {
                                  selectedWorkOrderForms[i] =
                                      selectedWorkOrderForms[i]
                                          .copyWith(order: i + 1);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Tab 3 (Form Laporan)
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          // 🔹 Selector untuk Report
                          FormsSelector(
                            key: _reportKey,
                            selectedFormsOrder: selectedReportForms,
                            onAdd: (formOrder) {
                              setState(
                                  () => selectedReportForms.add(formOrder));
                            },
                            onRemove: (formOrder) {
                              setState(() {
                                selectedReportForms.remove(formOrder);
                                for (var i = 0;
                                    i < selectedReportForms.length;
                                    i++) {
                                  selectedReportForms[i] =
                                      selectedReportForms[i]
                                          .copyWith(order: i + 1);
                                }
                              });
                            },
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) newIndex -= 1;
                                final item =
                                    selectedReportForms.removeAt(oldIndex);
                                selectedReportForms.insert(newIndex, item);
                                for (var i = 0;
                                    i < selectedReportForms.length;
                                    i++) {
                                  selectedReportForms[i] =
                                      selectedReportForms[i]
                                          .copyWith(order: i + 1);
                                }
                              });
                            },
                          ),
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
