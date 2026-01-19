import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/service_form_entity.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:workorder_company_app/features/services/presentation/pages/service_detail/service_detail_skeleton.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_access_chip.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_form_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/active_status_chip.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

part 'service_detail_widget_builder.dart';

class ServiceDetailPage extends StatefulWidget {
  final String serviceId;

  const ServiceDetailPage({super.key, required this.serviceId});

  @override
  State<ServiceDetailPage> createState() => ServiceDetailPageState();
}

class ServiceDetailPageState extends State<ServiceDetailPage> {
  late final ServicesBloc _servicesBloc;

  @override
  void initState() {
    super.initState();
    _servicesBloc = sl<ServicesBloc>()
      ..add(GetServiceByIdRequested(widget.serviceId));
  }

  @override
  void dispose() {
    _servicesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ServicesBloc, ServicesState>(
                    bloc: _servicesBloc,
                    builder: (context, state) {
                      String appBarTitle = "";
                      if (state is ServicesLoaded &&
                          state.selectedService != null) {
                        appBarTitle = state.selectedService!.title;
                      }

                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              IconBox(
                                paddingSize: AppSpacing.md,
                                icon: Icons.build_circle_outlined),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  appBarTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ));
                    }),
                // TabBar
                const TabBar(
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: "Konfigurasi"),
                    Tab(text: "Tugas Kerja"),
                    Tab(text: "Laporan"),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<ServicesBloc, ServicesState>(
          bloc: _servicesBloc,
          builder: (context, state) {
            return _buildBody(state);
          },
        ),
      ),
    );
  }

  Widget _buildBody(ServicesState state) {
    if (state is ServicesLoading || state is ServicesInitial) {
      return ServiceDetailSkeleton();
    }

    if (state is ServicesError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (state is ServicesLoaded) {
      if (state.isSubLoading == true) {
        return ServiceDetailSkeleton();
      }

      final service = state.selectedService;
      if (service == null) {
        return Center(
          child: Text(
            state.errorMessage ?? 'Service not found',
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      return TabBarView(
        children: [
          _buildOverviewTab(service),
          _buildFormsTab(service.workOrderForms, "WorkOrder Forms"),
          _buildFormsTab(service.reportForms, "Report Forms"),
        ],
      );
    }

    return const SizedBox();
  }
}
