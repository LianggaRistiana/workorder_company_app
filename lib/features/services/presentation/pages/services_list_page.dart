import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/service_permission.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_bloc.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_event.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_state.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_summary_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class ServicesListPage extends StatelessWidget {
  const ServicesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServicesListBloc>()..add(GetServicesRequested()),
      child: const _ServicesListView(),
    );
  }
}

class _ServicesListView extends StatelessWidget {
  const _ServicesListView();

  Future<void> _onRefresh(BuildContext context) async {
    context
        .read<ServicesListBloc>()
        .add(GetServicesRequested(forceRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServicesListBloc, ServicesListState>(
      listener: (context, state) {},
      builder: (context, state) {
        final isLoading = state.status == ServicesListStatus.loading;
        final errorMessage = state.errorMessage;
        final services = state.services;

        return ListPageScaffold(
            title: "Layanan",
            isLoading: isLoading,
            items: services,
            errorMessage: errorMessage,
            loadingMessage: "Memuat Layanan...",
            onRefresh: () => _onRefresh(context),
            emptyWidget: EmptyStateWidget(
              text: "Tidak ada layanan",
            ),
            floatingActionButton: PermissionGate(
              permission: ServicePermission.create,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  final result = await context.push(AppRoutes.servicesCreate);
                  if (!context.mounted) return;
                  if (result == true) {
                    context
                        .read<ServicesListBloc>()
                        .add(GetServicesRequested());
                  }
                },
                label: const Text("Tambah Layanan"),
                icon: const Icon(Icons.add),
              ),
            ),
            itemBuilder: (item) => ServiceSummaryItem(
                  key: ValueKey(item.id),
                  service: item,
                  isPublic: false,
                  onTap: () async {
                    final result = await context
                        .push(AppRoutes.servicesDetail.fillId(item.id));
                    if (!context.mounted) return;
                    if (result == true) {
                      context
                          .read<ServicesListBloc>()
                          .add(GetServicesRequested());
                    }
                  },
                ));
      },
    );
  }
}
