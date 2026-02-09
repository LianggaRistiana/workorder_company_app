import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_detail_cubit.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/client_name_chip.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/csr_status_chip.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';

class ServiceRequestDetailContent extends StatelessWidget {
  const ServiceRequestDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternalCsrDetailCubit, InternalCsrDetailState>(
      listener: (context, state) {
        if (state.status == CsrStateStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi kesalahan");
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case CsrStateStatus.loading:
            return const Center(child: AppLoading());

          case CsrStateStatus.loaded:
            final csr = state.clientServiceRequest;
            if (csr == null) return const SizedBox();
            return ServiceRequestDetailBody(csr: csr);

          default:
            return const Center(
              child: EmptyStateWidget(text: "Tidak ada data"),
            );
        }
      },
    );
  }
}

class ServiceRequestDetailBody extends StatelessWidget {
  final ClientServiceRequestEntity csr;

  const ServiceRequestDetailBody({
    super.key,
    required this.csr,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiceRequestHeader(csr: csr),
          const SizedBox(height: 8),
          if (csr.clientIntakeForms != null &&
              csr.clientIntakeForms!.isNotEmpty)
            CustomList(
              scrollable: false,
              separatorHeight: 16,
              items: csr.clientIntakeForms!,
              itemBuilder: (item, _) =>
                  FilledFormView(filledForm: item),
            ),
        ],
      ),
    );
  }
}

class ServiceRequestHeader extends StatelessWidget {
  final ClientServiceRequestEntity csr;

  const ServiceRequestHeader({
    super.key,
    required this.csr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                csr.service.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('d MMM yyyy', 'id_ID').format(csr.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            ClientNameChip(name: csr.client.name),
            const Spacer(),
            CsrStatusChip(status: csr.status, showIcon: true),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

