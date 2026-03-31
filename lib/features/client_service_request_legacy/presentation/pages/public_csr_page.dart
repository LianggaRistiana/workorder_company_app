import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/presentation/bloc/public_client_service_request/csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/presentation/widgets/csr_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/custom_back_buttom.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';

class PublicCsrPage extends StatefulWidget {
  const PublicCsrPage({super.key});

  @override
  State<PublicCsrPage> createState() => _PublicCsrPageState();
}

class _PublicCsrPageState extends State<PublicCsrPage> {
  @override
  void initState() {
    super.initState();
    context.read<CsrBloc>().add(GetClientServiceRequestsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Layanan"),
        leading: CustomBackButton(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            padding: EdgeInsets.only(
              left: AppSpacing.md,
              right: AppSpacing.md,
            ),
            child: CustomInputField(
              label: "Cari Pengajuan",
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CsrBloc, CsrState>(
        builder: (context, state) {
          // LOADING
          if (state.status == CsrStateStatus.loading &&
              state.clientServiceRequests.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
          if (state.status == CsrStateStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? "Terjadi kesalahan"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<CsrBloc>()
                          .add(GetClientServiceRequestsRequested());
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          // EMPTY
          if (state.clientServiceRequests.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<CsrBloc>()
                    .add(GetClientServiceRequestsRequested());
              },
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text("Belum ada pengajuan layanan.")),
                ],
              ),
            );
          }

          // LOADED — WITH PULL TO REFRESH
          return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<CsrBloc>()
                    .add(GetClientServiceRequestsRequested());
              },
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        HorizontalButton(
                          margin: const EdgeInsets.all(AppSpacing.md),
                          title: "Riwayat Pengajuan",
                          description:
                              "Lihat Pengajuan yang dibatalkan, ditolak, dan telah selesai",
                          leadingIcon: Icons.history,
                          onTap: () {},
                        ),
                        CustomList(
                          scrollable: false,
                          separatorHeight: 0,
                          items: state.clientServiceRequests,
                          itemBuilder: (item, _) => CsrItem(
                            csr: item,
                            onTap: () {
                              context.push(AppRoutes.serviceRequestDetailClientSide
                                  .fillId(item.id));
                            },
                          ),
                        ),
                      ],
                    )),
              ));
        },
      ),
    );
  }
}
