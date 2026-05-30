import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/form_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/form_filter_button.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';
import 'package:workorder_company_app/shared/widgets/search_bar.dart';

class FormsListPage extends StatelessWidget {
  const FormsListPage({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context
        .read<FormsListBloc>()
        .add(GetFormsListRequested(forceRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<FormsListBloc>()..add(GetFormsListRequested()),
        child: BlocListener<FormsListBloc, FormsListState>(
          listener: (context, state) {
            if (state.status == FormsListStatus.error &&
                state.errorMessage != null) {
              context.showError(state.errorMessage!);
            }
          },
          child: BlocBuilder<FormsListBloc, FormsListState>(
            builder: (context, state) {
              final isLoading = state.status == FormsListStatus.loading ||
                  state.status == FormsListStatus.initial;
              final forms = state.filteredForms;
              final errorMessage = state.status == FormsListStatus.error
                  ? state.errorMessage
                  : null;

              return ListPageScaffold<FormEntity>(
                title: "Formulir",
                isLoading: isLoading,
                errorMessage: errorMessage,
                items: forms,
                loadingMessage: "Memuat formulir...",
                onRefresh: () {
                  return _onRefresh(context);
                },
                header: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8.0, top: 4, bottom: 4),
                        child: AppSearchBar(
                          featureName: "perintah kerja",
                          onChanged: (value) {
                            context.read<FormsListBloc>().add(
                                  SetFormFilter(
                                    state.filter.copyWith(search: value),
                                  ),
                                );
                          },
                          initialValue: state.filter.search,
                        ),
                      ),
                    ),
                    FormFilterButton(),
                  ],
                ),
                emptyWidget: const EmptyStateWidget(
                  text: "Tidak ada formulir",
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    context.push(AppRoutes.formsCreate);
                  },
                  label: const Text("Tambah Form"),
                  icon: const Icon(Icons.add),
                ).require(roleCan(FormPermission.create)),
                itemBuilder: (form) => ClickableCustomCard(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  onTap: () {
                    context.push(AppRoutes.formsDetail.fillId(form.id));
                  },
                  child: Row(
                    children: [
                      IconBox(icon: AppIcon.form),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              form.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              form.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
