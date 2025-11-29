import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_detail_cubit.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/csr_status_step.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';

class PublicCsrDetailPage extends StatefulWidget {
  final String csrId;
  const PublicCsrDetailPage({super.key, required this.csrId});

  @override
  State<PublicCsrDetailPage> createState() => _CsrDetailPageState();
}

class _CsrDetailPageState extends State<PublicCsrDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CsrDetailCubit>().getCsrDetail(widget.csrId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengajuan Layanan")),
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
                // SizedBox(
                //   child: Stepper(
                //     type: StepperType.vertical,
                //     controlsBuilder: (context, details) => const SizedBox.shrink(),
                //     currentStep: 1,
                //     stepIconBuilder: (stepIndex, stepState) => stepState > stepIndex ? Colors.blue : Colors.black,

                //     onStepTapped: (index) {},
                //     steps: [
                //       Step(title: Text('Step 1'), content: const SizedBox.shrink()),
                //       Step(title: Text('Step '), content: const SizedBox.shrink()),
                //       Step(title: Text('Step 2'), content: const SizedBox.shrink()),
                //       Step(title: Text('Step 3'), content: const SizedBox.shrink()),
                //     ],
                //   ),
                // ),
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
        Row(
          children: [
            Text(
              csr.service.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                  ),
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
        CsrStatusStep(status: csr.status),
        const SizedBox(height: 12),
      ],
    );
  }
}
