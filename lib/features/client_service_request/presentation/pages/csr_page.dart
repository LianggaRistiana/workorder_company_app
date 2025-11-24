import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

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
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.clientServiceRequests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final csr = state.clientServiceRequests[index];
                return _CsrCard(csr: csr);
              },
            ),
          );
        },
      ),
    );
  }
}

class _CsrCard extends StatelessWidget {
  final ClientServiceRequestEntity csr;

  const _CsrCard({required this.csr});

  Color _statusColor(ClientServiceRequestStatus status) {
    switch (status) {
      case ClientServiceRequestStatus.received:
        return Colors.grey;
      case ClientServiceRequestStatus.underReview:
        return Colors.blueGrey;
      case ClientServiceRequestStatus.approved:
        return Colors.blue;
      case ClientServiceRequestStatus.workOrderCreated:
        return Colors.orange;
      case ClientServiceRequestStatus.completed:
        return Colors.green;
      case ClientServiceRequestStatus.rejected:
        return Colors.red;
      case ClientServiceRequestStatus.cancelled:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat("dd MMM yyyy").format(csr.createdAt);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.push(AppRoutes.managerCsr.byId(csr.id));
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                csr.service.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Oleh: ${csr.client.name}"),
                  Text(dateFormatted),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _statusColor(csr.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  csr.status.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _statusColor(csr.status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
