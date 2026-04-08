import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/detail/form_detail_cubit.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/detail/form_detail_state.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/form_field_card.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/form_type_tips.dart';
import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/header_of_page.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class FormDetailPage extends StatelessWidget {
  final String formId;
  const FormDetailPage({super.key, required this.formId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FormDetailCubit>()..getFormById(formId),
      child: _FormDetailView(
        formId: formId,
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
  bool isUpdated = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormDetailCubit, FormDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              if (state.form != null)
                IconButton(
                  onPressed: () async {
                    final result = await context.push<FormEntity>(
                        AppRoutes.formsUpdate,
                        extra: state.form);
                    if (!context.mounted) return;
                    if (result != null) {
                      context.read<FormDetailCubit>().replace(result);
                      isUpdated = true;
                      debugPrint(isUpdated.toString());
                    }
                  },
                  icon: const Icon(AppIcon.edit, size: 18),
                ),
            ],
          ),
          body: SafeArea(
            child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (!context.mounted) return;
                  context.pop(isUpdated);
                },
                child: _buildBody(context, state)),
          ),
        );
      },
    );
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
      const SizedBox(height: 12),
      CustomCard(
          child: PropertyDisplay(properties: [
        PropertyItem.text(
          label: 'Deskripsi',
          icon: Icons.info_outline,
          value: form.description,
        ),
        PropertyItem.text(
          label: 'Tipe Formulir',
          icon: Icons.category_outlined,
          value: form.formType.displayName,
        ),
        PropertyItem.text(
          label: 'Jumlah Pertanyaan',
          icon: Icons.question_mark_outlined,
          value: form.fields?.length.toString() ?? "-",
        ),
      ])),
      HelpButton(title: "Kenali Tipe Formulir", child: FormTypeTips()),
      const SizedBox(height: 16),
    ];
  }

  List<Widget> _formFields(FormEntity form) {
    return [
      PropertyTitle(label: "Daftar Pertanyaan", icon: Icons.question_mark),
      const SizedBox(height: 12),
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
