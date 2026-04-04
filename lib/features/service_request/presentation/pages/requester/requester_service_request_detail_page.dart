import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/service_request_content.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_request_detail/requester_service_request_detail_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_request_detail/requester_service_request_detail_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class RequesterServiceRequestDetailPage extends StatelessWidget {
  final String id;

  const RequesterServiceRequestDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<RequesterServiceRequestDetailCubit>()..getServiceRequestDetail(id),
      child: BlocConsumer<RequesterServiceRequestDetailCubit,
          RequesterServiceRequestDetailState>(listener: (context, state) {
        if (state.status == RequesterServiceRequestDetailStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi Kesalahan");
        }
      }, builder: (context, state) {
        final isLoading =
            state.status == RequesterServiceRequestDetailStatus.loading;

        return Scaffold(
          appBar: AppBar(),
          body: ServiceRequestContent(
            isLoading: isLoading,
            serviceRequest: state.request,
          ),
        );
      }),
    );
  }
}
