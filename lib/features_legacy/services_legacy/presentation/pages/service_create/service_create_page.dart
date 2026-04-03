import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_event.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/presentation/pages/service_create/service_config_tab.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/presentation/pages/service_create/service_request_config_tab.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/presentation/pages/service_create/service_work_order_tab.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/presentation/pages/service_create/service_work_report_tab.dart';
import 'package:workorder_company_app/shared/widgets/custom_step_indicator.dart';
import 'package:workorder_company_app/shared/widgets/step_navigation_bar.dart';

class ServiceCreatePage extends StatefulWidget {
  const ServiceCreatePage({super.key});

  @override
  State<ServiceCreatePage> createState() => _ServiceCreatePageState();
}

class _ServiceCreatePageState extends State<ServiceCreatePage>
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
        // final formValid = _serviceKey.currentState?.validate() ?? false;

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
                    onPressed: () {},
                    icon: const Icon(Icons.save),
                    label: Text("Simpan"))),
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Form(
                  key: _serviceKey,
                  child: ServiceConfigTab(),
                ),
                ServiceRequestConfigTab(),
                ServiceWorkOrderTab(),
                ServiceWorkReportTab(),
              ],
            )));
  }
}
