import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/service_type_tips.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/detail/service_detail_cubit.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/detail/service_detail_state.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_action_bottom_bar.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_config_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_request_tab_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_work_order_tab_view.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/header_of_page.dart';

class ServiceDetailPage extends StatelessWidget {
  final String serviceId;
  const ServiceDetailPage({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServiceDetailCubit>()..getServiceDetail(serviceId),
      child: const _ServiceDetailView(),
    );
  }
}

class _ServiceDetailView extends StatelessWidget {
  const _ServiceDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServiceDetailCubit, ServiceDetailState>(
      listener: (context, state) {
        if (state.status == ServiceDetailStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi Kesalahan");
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case ServiceDetailStatus.initial:
          case ServiceDetailStatus.error:
            return const Scaffold(
              body: SizedBox(),
            );

          case ServiceDetailStatus.loading:
            return const Scaffold(
              body: Center(child: AppLoading()),
            );

          case ServiceDetailStatus.loaded:
            final service = state.service!;
            final icon = AppIcon.service;

            return Scaffold(
              appBar: AppBar(
                title: const Text("Detail Layanan"),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () async {
                      final result = await context
                          .push(AppRoutes.servicesUpdate, extra: service);
                      if (!context.mounted) return;
                      if (result == true) {
                        context.pop(true);
                      }
                    },
                    icon: const Icon(AppIcon.edit, size: 18),
                  ),
                ],
              ),
              bottomNavigationBar: ServiceActionBottomBar(),
              body: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: HeaderOfPage(
                        title: service.title,
                        icon: icon,
                      ),
                    ),
                    const TabBar(
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(child: FittedBox(child: Text("Konfigurasi"))),
                        Tab(child: FittedBox(child: Text("Permintaan"))),
                        Tab(
                          child: FittedBox(
                            child: Text("Perintah Kerja\ndan Laporan"),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                              ),
                              child: Column(
                                children: [
                                  ServiceConfigView(service: service),
                                  HelpButton(
                                    title: "Ketahui jenis akses layanan",
                                    child: ServiceAccessTypeTips(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ServiceRequestTabView(
                            config: service.serviceRequestConfig,
                          ),
                          ServiceWorkOrderTabView(
                            configs: service.workOrdersConfig,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
