import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/service_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/fab_help.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_bloc.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_event.dart';
import 'package:workorder_company_app/features/services/presentation/bloc/list/services_list_state.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_summary_item.dart';
import 'package:workorder_company_app/features/work_order/presentation/helper/work_order_create_pop_up.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class ServicesListPage extends StatelessWidget {
  final ServiceListNextAction nextStepMode;
  const ServicesListPage(
      {super.key, this.nextStepMode = ServiceListNextAction.serviceDetail});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServicesListBloc>()..add(GetServicesRequested()),
      child: _ServicesListView(nextStepMode),
    );
  }
}

class _ServicesListView extends StatelessWidget {
  final ServiceListNextAction nextStepMode;

  const _ServicesListView(
    this.nextStepMode,
  );

  Future<void> _onRefresh(BuildContext context) async {
    context
        .read<ServicesListBloc>()
        .add(GetServicesRequested(forceRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServicesListBloc, ServicesListState>(
      listener: (context, state) {
        if (state.status == ServicesListStatus.error &&
            state.errorMessage != null) {
          context.showError(state.errorMessage!);
        }
      },
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
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FabHelp(
                  title: "Layanan",
                  heroTag: "service-list-tag",
                  child: InformationBlock.warning("Under Development"),
                ),
                if (nextStepMode == ServiceListNextAction.serviceDetail) ...[
                  const SizedBox(height: 8),
                  FloatingActionButton.extended(
                    onPressed: () {
                      context.push(AppRoutes.servicesCreate);
                    },
                    label: const Text("Tambah Layanan"),
                    icon: const Icon(Icons.add),
                  ).require(roleCan(ServicePermission.create)),
                ]
              ],
            ),
            itemBuilder: (item) => ServiceSummaryItem(
                  key: ValueKey(item.id),
                  service: item,
                  isPublic: false,
                  onTap: () {
                    switch (nextStepMode) {
                      case ServiceListNextAction.serviceDetail:
                        context.push(
                          AppRoutes.servicesDetail.fillId(item.id),
                        );
                        break;
                      case ServiceListNextAction.createServiceRequest:
                        context.push(
                          AppRoutes.serviceRequestCreate.fillId(
                            item.id,
                          ),
                          extra: item,
                        );
                        break;
                      case ServiceListNextAction.createWorkOrder:
                        showWorkOrderCreateConfirmDialog(context, item);
                        break;
                    }
                  },
                ));
      },
    );
  }
}
