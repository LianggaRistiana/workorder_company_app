import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_enum.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/service_request/domain/authorization/requester_service_request_authorizer.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_bloc.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_event.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_state.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class RequesterServiceRequestListPage extends StatelessWidget {
  const RequesterServiceRequestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RequesterServiceRequestsListBloc>()
        ..add(GetRequesterServiceRequestsRequested()),
      child: BlocConsumer<RequesterServiceRequestsListBloc,
          RequesterServiceRequestsListState>(listener: (context, state) {
        if (state.status == RequesterServiceRequestsListStatus.error) {
          context.showError(state.errorMessage ??
              "Terjadi kesalahan saat memuat daftar permintaan layanan");
        }
      }, builder: (context, state) {
        final items = state.requests;

        return ListPageScaffold<RequesterServiceRequestEntity>(
          title: 'Daftar Permintaan Layanan',
          isLoading: state.status == RequesterServiceRequestsListStatus.loading,
          onRefresh: () async {
            context
                .read<RequesterServiceRequestsListBloc>()
                .add(GetRequesterServiceRequestsRequested());
          },
          floatingActionButton: FloatingActionButton.extended(
                  icon: Icon(AppIcon.send),
                  onPressed: () => context.push(AppRoutes.services,
                      extra: ServiceListNextAction.createServiceRequest),
                  label: Text("Buat Permintaan Layanan"))
              .require(InternalServiceRequestCreateRule()),
          items: items,
          itemBuilder: (item) {
            return ServiceRequestItem(
              serviceRequest: item,
              onTap: () {
                context.push(AppRoutes.serviceRequestDetail.fillId(item.id),
                    extra: ServiceRequestSide.requester);
              },
            );
          },
        );
      }),
    );
  }
}
