import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/positions_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/widget/positions_selector.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_step_indicator.dart';
import 'package:workorder_company_app/shared/widgets/step_navigation_bar.dart.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/form_order_entity.dart';
import '../../domain/entities/required_staff_entity.dart';
import '../bloc/services_bloc.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({super.key});

  @override
  State<CreateServicePage> createState() => _CreateServicePageState();
}

// FIXME : Not Tested yet, Sperated Logic From UI
extension _UiLogic on _CreateServicePageState {
  void _onNext(BuildContext context) {
    final currentIndex = _tabController.index;
    bool isValid = false;

    switch (currentIndex) {
      case 0:
        final formValid = _serviceKey.currentState?.validate() ?? false;

        if (requiredStaff.isEmpty || !_validateRequiredStaff()) {
          isValid = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Posisi Belum diisi')),
          );
        } else {
          isValid = formValid;
        }
        break;
      case 1:
        if (selectedWorkOrderForms.isNotEmpty) {
          isValid = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form Workorder Belum diisi')),
          );
        }
        break;
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
    if (selectedReportForms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Laporan Belum diisi')),
      );
      return;
    }

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
}

class _CreateServicePageState extends State<CreateServicePage>
    with TickerProviderStateMixin {
  final _serviceKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  late final TabController _tabController;
  late final ServicesBloc _servicesBloc;
  late final FormsBloc _formsBloc;
  late final PositionsBloc _positionsBloc;

  List<RequiredStaffEntity> requiredStaff = [];
  List<FormOrderEntity> selectedWorkOrderForms = [];
  List<FormOrderEntity> selectedReportForms = [];
  String accessType = 'internal';
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    _servicesBloc = sl<ServicesBloc>();
    _formsBloc = sl<FormsBloc>()..add(GetFormsRequested());
    _positionsBloc = sl<PositionsBloc>()..add(GetPositionsRequested());
    _tabController = TabController(length: 3, vsync: this);
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
    _servicesBloc.close();
    _formsBloc.close();
    _positionsBloc.close();
    super.dispose();
  }

  Widget _buildServiceSetting() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
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
            const Text('Status Layanan',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Aktif')),
                    selected: isActive,
                    onSelected: (val) => setState(() => isActive = true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                      label: const Center(child: Text('Tidak aktif')),
                      selected: !isActive,
                      onSelected: (val) => setState(() => isActive = false)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionsRequiredSetting() {
    return PositionsSelector(
      selectedPositions: requiredStaff.map((s) => s.position).toList(),
      onAdd: (pos) {
        setState(() {
          requiredStaff.add(RequiredStaffEntity(
            position: pos,
            minimumStaff: 1,
            maximumStaff: 1,
          ));
        });
      },
      onRemove: (pos) {
        setState(() {
          requiredStaff.removeWhere((s) => s.position.id == pos.id);
        });
      },
      itemBuilder: (position) {
        final staff =
            requiredStaff.firstWhere((s) => s.position.id == position.id);

        final minController =
            TextEditingController(text: staff.minimumStaff.toString());
        final maxController =
            TextEditingController(text: staff.maximumStaff.toString());

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    staff.position.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: minController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration:
                        const InputDecoration(labelText: 'Min', isDense: true),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) {
                        setState(() {
                          final index = requiredStaff.indexOf(staff);
                          requiredStaff[index] =
                              staff.copyWith(minimumStaff: parsed);
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
                    decoration:
                        const InputDecoration(labelText: 'Max', isDense: true),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) {
                        setState(() {
                          final index = requiredStaff.indexOf(staff);
                          requiredStaff[index] =
                              staff.copyWith(maximumStaff: parsed);
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() => requiredStaff.remove(staff));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _servicesBloc),
        BlocProvider.value(value: _formsBloc),
        BlocProvider.value(value: _positionsBloc),
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
              title: const Text('Buat Layanan'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(72),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomStepIndicator(
                    currentStep: _tabController.index,
                    steps: const [
                      'Pengaturan Layanan',
                      'Form WO',
                      'Form Laporan'
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: StepNavigationBar(
                currentStep: _tabController.index,
                totalSteps: 3,
                onPrevious: _onPrevious,
                onNext: () => _onNext(context),
                finalAction: BlocSelector<ServicesBloc, ServicesState, bool>(
                  selector: (state) =>
                      state is ServicesLoaded ? state.isSubLoading : false,
                  builder: (context, isLoading) {
                    return ElevatedButton(
                      onPressed: isLoading ? null : _onSubmit,
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
                                Text('Simpan Layanan'),
                              ],
                            ),
                    );
                  },
                )),
            body: BlocBuilder<ServicesBloc, ServicesState>(
              buildWhen: (previous, current) {
                if (previous is ServicesLoaded && current is ServicesLoaded) {
                  return previous.isSubLoading != current.isSubLoading;
                }
                return previous.runtimeType != current.runtimeType;
              },
              builder: (context, state) {
                return TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Tab 1
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _serviceKey,
                        child: Column(
                          children: [
                            _buildServiceSetting(),
                            const SizedBox(height: 24),
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
