import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_detail_cubit.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/data/model/option_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/submissions/data/model/field_data_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';

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
                const Divider(height: 32),
                _infoSection(csr),
                const Divider(height: 32),
                _formsSection(csr),
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

  Widget _infoSection(csr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Info CSR", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        _infoTile("CSR ID", csr.id),
        _infoTile("Tanggal Dibuat", csr.createdAt.toString()),
        _infoTile("Company ID", csr.companyId),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _formsSection(csr) {
    final forms = csr.clientIntakeForms ?? [];

    if (forms.isEmpty) {
      return const Text("Tidak ada intake form.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Client Intake Forms",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ...forms.map((filled) {
          final submission = filled.submission;

          return Card(
            elevation: 0.4,
            child: ExpansionTile(
              title: Text(filled.form.title),
              subtitle: Text(
                submission != null ? "Sudah diisi" : "Belum diisi",
              ),
              children: [
                if (submission != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _fieldsView(filled),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _fieldsView(filled) {
    final formFields = filled.form.fields ?? [];
    final submission = filled.submission;
    final answers = submission?.fieldsData ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...formFields.map((field) {
        final answer = answers
            .firstWhere(
              (f) => f.order == (field.order?.toString() ?? ""),
              // FIXME : USE ENTITY INSTEAD OF MODEL, RN its error if using entity idk why
              orElse: () => FieldDataModel(order: "", value: null),
            )
            .value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              _answerWidget(field, answer),
            ],
          ),
        );
      }),]
    );
  }

  Widget _answerWidget(FieldEntity field, dynamic answer) {
    if (answer == null || answer.toString().isEmpty) {
      return const Text("-");
    }

    switch (field.type) {
      case FieldType.text:
      case FieldType.textarea:
        return Text(answer.toString());

      case FieldType.email:
        return GestureDetector(
          onTap: () {},
          child: Text(
            answer.toString(),
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        );

      case FieldType.number:
        return Text(answer.toString());

      case FieldType.date:
        try {
          final parsed = DateTime.tryParse(answer.toString());
          return Text(parsed != null
              ? "${parsed.day}-${parsed.month}-${parsed.year}"
              : answer.toString());
        } catch (_) {
          return Text(answer.toString());
        }

      case FieldType.time:
        return Text(answer.toString()); // jam biasanya sudah string "HH:mm"

      case FieldType.singleSelect:
        final opt = field.options?.firstWhere(
          (o) => o.key == answer,
          // FIXME : Use Entity
          orElse: () => OptionModel(key: "", value: answer.toString()),
        );
        return Text(opt?.value ?? answer.toString());

      case FieldType.multiSelect:
        if (answer is List) {
          final labels = answer.map((a) {
            final opt = field.options?.firstWhere(
              (o) => o.key == a,
              // FIXME USE ENTITY
              orElse: () => OptionModel(key: "", value: a.toString()),
            );
            return opt?.value ?? a.toString();
          }).join(", ");

          return Text(labels);
        }
        return Text(answer.toString());
    }
  }
}
