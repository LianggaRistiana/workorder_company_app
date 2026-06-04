import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/authorizer/form_authorizer.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/meta/form_detail_meta.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/delete/form_delete_cubit.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/delete/form_delete_state.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/detail/form_detail_cubit.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/detail/form_detail_state.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_property_view.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/form_field_card.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/form_type_tips.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/header_of_page.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

// OPTIMIZE : add sliver to support lazy load
class FormDetailPage extends StatelessWidget {
  final String formId;
  const FormDetailPage({super.key, required this.formId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FormDetailCubit>()..getFormById(formId),
        ),
        BlocProvider(
          create: (context) => sl<FormDeleteCubit>(),
        ),
      ],
      child: BlocListener<FormDeleteCubit, FormDeleteState>(
        listener: (context, state) {
          if (state.status == FormDeleteStatus.deleted) {
            context.showSuccess("Berhasil Menghapus Formulir");
            context.pop();
          }
          if (state.status == FormDeleteStatus.error) {
            context.showError(state.errorMessage ?? "Gagal Menghapus Formulir");
          }
        },
        child: _FormDetailView(
          formId: formId,
        ),
      ),
    );
  }
}

class _FormDetailView extends StatefulWidget {
  final String formId;

  const _FormDetailView({required this.formId});

  @override
  State<_FormDetailView> createState() => _FormDetailViewState();
}

class _FormDetailViewState extends State<_FormDetailView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormDetailCubit, FormDetailState>(
      builder: (context, state) {
        final form = state.form;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              if (form != null)
                IconButton(
                  onPressed: () async {
                    final result = await context
                        .push<FormEntity>(AppRoutes.formsUpdate, extra: form);
                    if (!context.mounted) return;
                    if (result != null) {
                      context.read<FormDetailCubit>().replace(result);
                    }
                  },
                  icon: const Icon(AppIcon.edit, size: 18),
                ).require(FormAuthorizer(form: form).updateFormRule),
              if (form != null) _buildDeleteButton(context, form, state.meta)
            ],
          ),
          body: SafeArea(
            child: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildDeleteButton(
      BuildContext context, FormEntity form, FormDetailMeta? meta) {
    return BlocBuilder<FormDeleteCubit, FormDeleteState>(
        builder: (context, state) {
      return IconButton(
        onPressed: () async {
          final result = await showConfirmDialog(
              type: ConfirmDialogType.danger,
              context: context,
              title: "Hapus Formulir",
              message: "Apakah anda yakin ingin menghapus formulir ini?");
          if (!context.mounted) return;
          if (result == true) {
            context.read<FormDeleteCubit>().deleteForm(form);
          }
        },
        icon: Icon(AppIcon.delete,
            size: 18, color: ColorScheme.of(context).error),
      )
          .require(
            FormAuthorizer(form: form, meta: meta).deleteFormRule,
          )
          .withInlineLoading(state.status == FormDeleteStatus.loading);
    });
  }

  Widget _buildBody(BuildContext context, FormDetailState state) {
    switch (state.status) {
      case FormDetailStatus.loading:
        return const Center(child: AppLoading());

      case FormDetailStatus.error:
        return ErrorBody(
          errorMessage: state.errorMessage,
          onRetry: () {
            context.read<FormDetailCubit>().getFormById(widget.formId);
          },
        );

      case FormDetailStatus.loaded:
        final form = state.form;
        if (form == null) {
          return ErrorBody(
            errorMessage: "Form tidak ditemukan",
            onRetry: () {
              context.read<FormDetailCubit>().getFormById(widget.formId);
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<FormDetailCubit>().getFormById(widget.formId);
          },
          child: AdaptiveSplitColumn(
            heightSpacing: 0,
            leftChildren: _formMetaData(form),
            rightChildren: _formFields(form),
          ),
        );

      case FormDetailStatus.initial:
        return const SizedBox.shrink();
    }
  }

  List<Widget> _formMetaData(FormEntity form) {
    return [
      HeaderOfPage(title: form.title, icon: AppIcon.form),
      const SizedBox(height: AppSpacing.sm),
      FormPropertyView(form: form),
      HelpButton(title: "Kenali Tipe Formulir", child: FormTypeTips()),
      const SizedBox(height: AppSpacing.md),
    ];
  }

  List<Widget> _formFields(FormEntity form) {
    return [
      PropertyTitle(label: "Daftar Pertanyaan", icon: Icons.question_mark),
      const SizedBox(height: AppSpacing.md),
      CustomList(
        items: form.fields ?? [],
        emptyFooterHeight: AppSpacing.lg,
        emptyWidget: InformationBlock.empty("Belum ada pertanyaan"),
        itemBuilder: (context, index) {
          final field = form.fields![index];
          return FormFieldCard(field: field);
        },
      )
    ];
  }
}
