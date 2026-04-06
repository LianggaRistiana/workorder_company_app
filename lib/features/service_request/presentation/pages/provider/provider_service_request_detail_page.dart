import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/service_request_content.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_request_detail/provider_service_request_detail_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_request_detail/provider_service_request_detail_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class ProviderServiceRequestDetailPage extends StatelessWidget {
  final String id;

  const ProviderServiceRequestDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProviderServiceRequestDetailCubit>()..getServiceRequestDetail(id),
      child: BlocConsumer<ProviderServiceRequestDetailCubit,
          ProviderServiceRequestDetailState>(listener: (context, state) {
        if (state.status == ProviderServiceRequestDetailStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi Kesalahan");
        }
      }, builder: (context, state) {
        final isLoading =
            state.status == ProviderServiceRequestDetailStatus.loading;
        final serviceRequest = state.request;

        return Scaffold(
          appBar: AppBar(),
          // bottomNavigationBar: serviceRequest != null
          // ? _actionWidget(context, serviceRequest)
          // : null,
          body: ServiceRequestContent(
            isLoading: isLoading,
            serviceRequest: serviceRequest,
          ),
        );
      }),
    );
  }
}
