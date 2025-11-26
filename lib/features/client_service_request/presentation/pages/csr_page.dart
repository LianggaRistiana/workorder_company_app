import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/csr_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';

class CsrPage extends StatefulWidget {
  const CsrPage({super.key});

  @override
  State<CsrPage> createState() => _CsrPageState();
}

class _CsrPageState extends State<CsrPage> {
  @override
  void initState() {
    super.initState();
    context.read<InternalCsrBloc>().add(GetClientServiceRequestsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Layanan"),
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
      body: BlocBuilder<InternalCsrBloc, InternalCsrState>(
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
                          .read<InternalCsrBloc>()
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
                    .read<InternalCsrBloc>()
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
                    .read<InternalCsrBloc>()
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
                              context.push(AppRoutes.managerCsr.byId(item.id));
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
