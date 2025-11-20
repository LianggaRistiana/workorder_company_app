import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_detail_cubit.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';

class CsrDetailPage extends StatefulWidget {
  final String csrId;
  const CsrDetailPage({super.key, required this.csrId});

  @override
  State<CsrDetailPage> createState() => _CsrDetailPageState();
}

class _CsrDetailPageState extends State<CsrDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CsrDetailCubit>().getCsrDetail(widget.csrId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CSR Detail")),
      body: BlocBuilder<CsrDetailCubit, CsrDetailState>(
        builder: (context, state) {
          if (state.status == CsrStateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == CsrStateStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? "Terjadi kesalahan"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CsrDetailCubit>().getCsrDetail(widget.csrId);
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          final csr = state.clientServiceRequest;
          if (csr == null) return const SizedBox();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(csr),
                if (csr.clientIntakeForms != null &&
                    csr.clientIntakeForms!.isNotEmpty)
                  CustomList(
                      items: csr.clientIntakeForms!,
                      itemBuilder: (item, _) =>
                          FilledFormView(filledForm: item))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _header(ClientServiceRequestEntity csr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          csr.service.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text("Client: ${csr.client.name}"),
        const SizedBox(height: 12),
        Chip(label: Text(csr.status.name.toUpperCase())),
      ],
    );
  }
}
