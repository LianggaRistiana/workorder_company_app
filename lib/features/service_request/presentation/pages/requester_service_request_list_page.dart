import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_bloc.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_event.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_requests_list/requester_service_requests_list_state.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_item.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
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
          onRefresh: () async {},
          items: items,
          itemBuilder: (item) {
            return ServiceRequestItem.requester(
                serviceRequest: item, onTap: () {}, toCompany: item.company);
          },
        );
      }),
    );
  }
}
