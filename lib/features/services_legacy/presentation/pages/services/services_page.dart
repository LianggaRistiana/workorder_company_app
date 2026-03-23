import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/service_permission.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services_legacy/presentation/bloc/services_bloc.dart';
import 'package:workorder_company_app/features/services_legacy/presentation/widgets/service_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late final ServicesBloc _servicesBloc;

  @override
  void initState() {
    super.initState();
    _servicesBloc = sl<ServicesBloc>()..add(GetServicesRequested());
  }

  @override
  void dispose() {
    _servicesBloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _servicesBloc.add(GetServicesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _servicesBloc,
      child: BlocListener<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is ServicesError) {
            context.showError(state.message);
          }
        },
        child: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            final isLoading = state is ServicesLoading;
            final errorMessage = state is ServicesError ? state.message : null;
            final services =
                state is ServicesLoaded ? state.services ?? [] : <dynamic>[];

            return ListPageScaffold(
              title: "Layanan",
              isLoading: isLoading,
              errorMessage: errorMessage,
              items: services,
              loadingMessage: "Memuat layanan...",
              onRefresh: _onRefresh,
              emptyWidget: const EmptyStateWidget(
                icon: Icons.miscellaneous_services_outlined,
                text: "Tidak ada Layanan",
              ),
              floatingActionButton: PermissionGate(
                permission: ServicePermission.create,
                child: FloatingActionButton.extended(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final result =
                              await context.push(AppRoutes.servicesCreate);

                          if (result == true && context.mounted) {
                            context
                                .read<ServicesBloc>()
                                .add(GetServicesRequested());
                          }
                        },
                  label: const Text("Tambah Layanan"),
                  icon: const Icon(Icons.add),
                ),
              ),
              itemBuilder: (service) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: ServiceItem(
                  service: service,
                  isPublic: false,
                  onTap: () {
                    context.push(
                      AppRoutes.servicesDetail.fillId(service.id),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
