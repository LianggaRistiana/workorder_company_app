import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/csr_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';
class ServiceRequestContent extends StatelessWidget {
  const ServiceRequestContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalCsrBloc, InternalCsrState>(
      builder: (context, state) {
        return ListPageScaffold(
          title: "Pengajuan Layanan",
          isLoading: state.status == CsrStateStatus.loading,
          errorMessage: state.errorMessage,
          items: state.clientServiceRequests,
          loadingMessage: "Memuat pengajuan...",
          bottomAppBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              child: CustomInputField(
                label: "Cari Pengajuan",
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          onRefresh: () async {
            context
                .read<InternalCsrBloc>()
                .add(GetClientServiceRequestsRequested());
          },

          header: HorizontalButton(
            margin: const EdgeInsets.all(AppSpacing.md),
            title: "Riwayat Pengajuan",
            description:
                "Lihat Pengajuan yang dibatalkan, ditolak, dan telah selesai",
            leadingIcon: Icons.history,
            onTap: () {},
          ),

          itemBuilder: (item) => CsrItem(
            csr: item,
            onTap: () {
              context.push(
                AppRoutes.serviceRequestDetail.fillId(item.id),
              );
            },
          ),
        );
      },
    );
  }
}