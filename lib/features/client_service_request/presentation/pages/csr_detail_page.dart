import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/authorization/feature/csr_permission.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_detail_cubit.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/client_name_chip.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/csr_actions_button.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/csr_status_chip.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';

class CsrDetailPage extends StatefulWidget {
  final String csrId;
  const CsrDetailPage({required this.csrId, super.key});

  @override
  State<CsrDetailPage> createState() => _CsrDetailPageState();
}

class _CsrDetailPageState extends State<CsrDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<InternalCsrDetailCubit>().getCsrDetail(widget.csrId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalCsrDetailCubit, InternalCsrDetailState>(
      builder: (context, state) {
        final csr = state.clientServiceRequest;

        return Scaffold(
          appBar: AppBar(title: const Text("Detail Pengajuan Layanan")),

          // ⬇️ pakai state untuk bottom nav bar
          bottomNavigationBar: csr == null
              ? const SizedBox.shrink()
              : PermissionGate(
                  permission: CsrPermission.action,
                  child: CsrActionsButton(
                    csrStatus: csr.status,
                    csrId: widget.csrId,
                    onRefresh: () => context
                        .read<InternalCsrDetailCubit>()
                        .getCsrDetail(widget.csrId),
                  )),

          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(InternalCsrDetailState state) {
    if (state.status == CsrStateStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == CsrStateStatus.error) {
      return Center(
        // mainAxisSize: MainAxisSize.min,
        child: Column(
          children: [
            Text(state.errorMessage ?? "Terjadi kesalahan"),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context
                  .read<InternalCsrDetailCubit>()
                  .getCsrDetail(widget.csrId),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    final csr = state.clientServiceRequest;
    if (csr == null) return const SizedBox();

    return _buildContent(csr);
  }

  Widget _buildContent(ClientServiceRequestEntity csr) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(csr),
          const SizedBox(height: 8),
          if (csr.clientIntakeForms != null &&
              csr.clientIntakeForms!.isNotEmpty)
            CustomList(
              scrollable: false,
              separatorHeight: 16,
              items: csr.clientIntakeForms!,
              itemBuilder: (item, _) => FilledFormView(filledForm: item),
            ),
        ],
      ),
    );
  }

  Widget _header(ClientServiceRequestEntity csr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              csr.service.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              DateFormat('d MMM yyyy', 'id_ID').format(csr.createdAt),
              textAlign: TextAlign.end,
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
