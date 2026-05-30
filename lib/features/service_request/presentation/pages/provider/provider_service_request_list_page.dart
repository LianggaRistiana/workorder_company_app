import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_bloc.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_event.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_requests_list/provider_service_requests_list_state.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/provider_service_request_filter_button.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class ProviderServiceRequestListPage extends StatelessWidget {
  const ProviderServiceRequestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProviderServiceRequestsListBloc>()
        ..add(GetProviderServiceRequestsRequested()),
      child: BlocConsumer<ProviderServiceRequestsListBloc,
          ProviderServiceRequestsListState>(listener: (context, state) {
        if (state.status == ProviderServiceRequestsListStatus.error) {
          context.showError(state.errorMessage ??
              "Terjadi kesalahan saat memuat daftar permintaan layanan");
        }
      }, builder: (context, state) {
        final items = state.filteredRequests;

        return ListPageScaffold<ProviderServiceRequestEntity>(
          title: 'Daftar Permintaan Layanan',
          isLoading: state.status == ProviderServiceRequestsListStatus.loading,
          onRefresh: () async {
            context.read<ProviderServiceRequestsListBloc>().add(
                  GetProviderServiceRequestsRequested(forceRefresh: true),
                );
          },
          header: Row(
            children: [
              Spacer(),
              ProviderServiceRequestFilterButton(),
            ],
          ),
          items: items,
          itemBuilder: (item) {
            return ServiceRequestItem(
              serviceRequest: item,
              onTap: () {
                context.push(AppRoutes.serviceRequestDetail.fillId(item.id),
                    extra: ServiceRequestSide.provider);
              },
            );
          },
        );
      }),
    );
  }
}
