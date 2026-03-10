import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/detail/form_detail_cubit.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/detail/form_detail_state.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/form_field_card.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_back_buttom.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class FormDetailPage extends StatefulWidget {
  final String formId;

  const FormDetailPage({super.key, required this.formId});

  @override
  State<FormDetailPage> createState() => _FormDetailPageState();
}

class _FormDetailPageState extends State<FormDetailPage> {
  late final FormDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<FormDetailCubit>();
    _cubit.getFormById(widget.formId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormDetailCubit, FormDetailState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: CustomBackButton(),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, FormDetailState state) {
    switch (state.status) {
      case FormDetailStatus.loading:
        return const Center(child: AppLoading());

      case FormDetailStatus.error:
        return _buildErrorState(state.errorMessage ?? "Terjadi kesalahan");

      case FormDetailStatus.loaded:
        final form = state.form;
        if (form == null) {
          return _buildErrorState("Form tidak ditemukan");
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconBox(icon: Icons.assignment_turned_in_outlined),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      form.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ---- Description ----
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InformationBlock(
                      message: 'Formulir ${form.formType.displayName}',
                    ),
                    const SizedBox(height: 12),
                    Text(
                      form.description.isEmpty
                          ? 'Tidak ada deskripsi'
                          : form.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text(
                'Daftar Pertanyaan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),

              // ---- Fields ----
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: form.fields?.length ?? 0,
                itemBuilder: (context, index) {
                  final field = form.fields![index];
                  return FormFieldCard(field: field);
                },
              ),
            ],
          ),
        );

      case FormDetailStatus.initial:
        return const SizedBox.shrink();
    }
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
