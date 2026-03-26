import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<PositionsListBloc>().add(GetPositionsListRequested());
    context.read<FormsListBloc>().add(GetFormsListRequested());
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  void _onNext(BuildContext context) {
    final currentIndex = _tabController.index;
    bool isValid = true;
    // bool isValid = false;

    switch (currentIndex) {
      case 0:
        final formValid = _serviceKey.currentState?.validate() ?? false;

        // if (requiredStaff.isEmpty || !_validateRequiredStaff()) {
        //   isValid = false;
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Posisi Belum diisi')),
        //   );
        // } else {
        //   isValid = formValid;
        // }
        isValid = true;
        // isValid = formValid;
        break;
      case 1:
        // if (selectedWorkOrderForms.isNotEmpty) {
        //   isValid = true;
        // } else {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Form Workorder Belum diisi')),
        //   );
        // }
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
                  currentStep: _tabController.index,
                  totalSteps: 4,
                  onPrevious: _onPrevious,
                  onNext: () => _onNext(context),
                  finalAction: FilledButton.icon(
                      onPressed: () {
                        isLoading
                            ? null
                            : context.read<ServiceCreateCubit>().submit();
                      },
                      icon: const Icon(AppIcon.submit),
                      label: Text(isLoading ? "Loading..." : "Simpan"))),
              body: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Form(
                    key: _serviceKey,
                    child: ServiceConfigFormTabView(),
                  ),
                  ServiceRequestFormTabView(),
                  ServiceWorkOrderFormTabView(),
                  ServiceWorkReportFormTabView(),
                ],
              )));
    });
  }
}
