import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features/services/domain/draft/service_draft.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/create/service_create_state.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_config_form_tab_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_request_form_tab_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_work_order_form_tab_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_work_report_form_tab_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_step_indicator.dart';
import 'package:workorder_company_app/shared/widgets/step_navigation_bar.dart';

class ServiceCreatePage extends StatelessWidget {
  const ServiceCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ServiceCreateCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<PositionsListBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<FormsListBloc>(),
        )
      ],
      child: _ServiceCreateView(),
    );
  }
}

class _ServiceCreateView extends StatefulWidget {
  const _ServiceCreateView();

  @override
  State<_ServiceCreateView> createState() => __ServiceCreateViewState();
}

class __ServiceCreateViewState extends State<_ServiceCreateView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final _serviceKey = GlobalKey<FormState>();
  late final ServiceConfigControllers _configControllers;

  late ServiceDraft _draft;

  @override
  void initState() {
    super.initState();
    context.read<PositionsListBloc>().add(GetPositionsListRequested());
    context.read<FormsListBloc>().add(GetFormsListRequested());

    _draft = ServiceDraft.initial();

    _configControllers = ServiceConfigControllers(
      title: TextEditingController(),
      description: TextEditingController(),
    );

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  void _onSubmit() {
    // if (!_serviceKey.currentState!.validate()) return;
    final title = _configControllers.title.text;
    final description = _configControllers.description.text;

    _draft = _draft.copyWith(
      title: title,
      description: description,
    );

    context.read<ServiceCreateCubit>().submit(_draft);
  }

  void _onNext(BuildContext context) {
    final currentIndex = _tabController.index;
    bool isValid = true;

    switch (currentIndex) {
      case 0:
        // TODO : check validation to next Tab
        break;
      case 1:
        // TODO : check validation to next Tab

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceCreateCubit, ServiceCreateState>(
        listener: (context, state) {
      if (state.status == ServiceCreateStatus.error) {
        context.showError(state.errorMessage ?? "Terjadi Kesalahan");
      }
      if (state.status == ServiceCreateStatus.success) {
        context.showSuccess("Berhasil Menyimpan Layanan Baru");
      }
    }, builder: (context, state) {
      final isLoading = state.status == ServiceCreateStatus.loading;

      return DefaultTabController(
          length: 4,
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
                        'Konfigurasi',
                        'Permintaan',
                        'Perintah Kerja',
                        'Laporan'
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: StepNavigationBar(
                isLoading: isLoading,
                currentStep: _tabController.index,
                totalSteps: 4,
                onPrevious: _onPrevious,
                onNext: () => _onNext(context),
                finalAction: FilledButton.icon(
                  onPressed: isLoading ? null : _onSubmit,
                  icon: const Icon(AppIcon.submit),
                  label: Text(isLoading ? "Loading..." : "Simpan"),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Form(
                    key: _serviceKey,
                    child: ServiceConfigFormTabView(
                      isActive: _draft.isActive,
                      onActiveChanged: (v) {
                        setState(() {
                          _draft = _draft.copyWith(isActive: v);
                        });
                      },
                      titleController: _configControllers.title,
                      descriptionController: _configControllers.description,
                      accessType: _draft.accessType,
                      onAccessTypeChanged: (v) {
                        setState(() {
                          _draft = _draft.copyWith(accessType: v);
                        });
                      },
                    ),
                  ),
                  ServiceRequestFormTabView(
                    approvalAccess: _draft.requestApprovalAccess,
                    onApprovalAccessChanged: (value) {
                      setState(() {
                        _draft = _draft.copyWith(
                          requestApprovalAccess: value,
                        );
                      });
                    },
                    intakeForm: _draft.intakeForm,
                    onIntakeFormChanged: (form) {
                      setState(() {
                        _draft = _draft.copyWith(intakeForm: form);
                      });
                    },
                    reviewForm: _draft.reviewForm,
                    onReviewFormChanged: (form) {
                      setState(() {
                        _draft = _draft.copyWith(reviewForm: form);
                      });
                    },
                  ),
                  ServiceWorkOrderFormTabView(
                    workOrders: _draft.workOrders,
                    onAdd: (form) {
                      setState(() {
                        _draft = _draft.addWorkOrder(form);
                      });
                    },
                    onRemove: (index) {
                      setState(() {
                        _draft = _draft.removeWorkOrder(index);
                      });
                    },
                    onDepartmentUpdate: (index, position) {
                      setState(() {
                        _draft = _draft.updateDepartment(index, position);
                      });
                    },
                    onMinChange: (index, value) {
                      setState(() {
                        _draft = _draft.updateMinStaff(index, value);
                      });
                    },
                    onMaxChange: (index, value) {
                      setState(() {
                        _draft = _draft.updateMaxStaff(index, value);
                      });
                    },
                    onApprovalChange: (index, value) {
                      setState(() {
                        _draft = _draft.updateApproval(index, value);
                      });
                    },
                  ),
                  ServiceWorkReportFormTabView(
                    workOrders: _draft.workOrders,
                    onApprovalChange: (index, value) {
                      setState(() {
                        _draft = _draft.updateWorkOrder(
                          index,
                          _draft.workOrders[index]
                              .copyWith(workReportApprovalAccess: value),
                        );
                      });
                    },
                    onFormUpdate: (index, form) {
                      setState(() {
                        _draft = _draft.updateWorkOrder(
                          index,
                          _draft.workOrders[index].copyWith(reportForm: form),
                        );
                      });
                    },
                  ),
                ],
              )));
    });
  }
}

class ServiceConfigControllers {
  final TextEditingController title;
  final TextEditingController description;

  ServiceConfigControllers({
    required this.title,
    required this.description,
  });

  void dispose() {
    title.dispose();
    description.dispose();
  }
}
