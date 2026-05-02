import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/service_type_tips.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_config_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_request_tab_view.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_work_order_tab_view.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_preview/service_preview_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_preview/service_preview_state.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/header_of_page.dart';

class ServiceTemplatesPreviewPage extends StatelessWidget {
  final String servicePreviewId;

  const ServiceTemplatesPreviewPage({
    super.key,
    required this.servicePreviewId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            sl<ServicePreviewCubit>()..fetchServicePreview(servicePreviewId),
        child: BlocConsumer<ServicePreviewCubit, ServicePreviewState>(
            listener: (context, state) {},
            builder: (context, state) {
              final service = state.servicePreview?.service;
              Widget body;
              if (state.isLoading) {
                body = Center(child: AppLoading());
              } else if (state.isSuccess && service != null) {
                body = SafeArea(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: HeaderOfPage(
                            title: service.title,
                            icon: AppIcon.service,
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
                                formShowType: FormShowType.previewPage,
                              ),
                              ServiceWorkOrderTabView(
                                configs: service.workOrdersConfig,
                                formShowType: FormShowType.previewPage,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                body = SizedBox.shrink();
              }

              return Scaffold(
                appBar: AppBar(
                  title: const Text("Preview Layanan"),
                ),
                body: body,
              );
            }));
  }
}
