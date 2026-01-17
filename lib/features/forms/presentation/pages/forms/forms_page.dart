import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/forms/forms_skeleton.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

class FormsPage extends StatefulWidget {
  const FormsPage({super.key});

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  late final FormsBloc _formBloc;

  @override
  void initState() {
    super.initState();
    _formBloc = GetIt.I<FormsBloc>()..add(GetFormsRequested());
  }

  @override
  void dispose() {
    _formBloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _formBloc.add(GetFormsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulir"),
        centerTitle: true,
      ),
      body: BlocListener<FormsBloc, FormsState>(
        bloc: _formBloc,
        listener: (context, state) {
          if (state is FormsError) {
            // showError
            context.showError(state.message);
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<FormsBloc, FormsState>(
          bloc: _formBloc,
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: Builder(
                builder: (context) {
                  if (state is FormsInitial || state is FormsLoading) {
                    return const FormsSkeleton();
                  }

                  if (state is FormsError) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(
                          child: EmptyStateWidget(
                            icon: Icons.warning_rounded,
                            text: "Ada Kesalahan",
                          ),
                        ),
                      ],
                    );
                  }

                  if (state is FormsLoaded) {
                    final forms = state.forms;

                    if (forms.isEmpty) {
                      return const Center(
                        child: EmptyStateWidget(
                          text: "Belum Ada Form",
                        ),
                      );
                    }

                    return _buildMainContent(forms);
                  }

                  // Default fallback kalau ada state lain
                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.ownerNewForm),
        label: const Text("Tambah Form"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMainContent(List<FormEntity> forms) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: CustomList(
          items: forms,
          emptyFooterHeight: 20,
          scrollable: true,
          isReorderable: false,
          itemBuilder: (form, _) => CustomCard(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(0),
            child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  context.push(AppRoutes.ownerFormDetail(form.id));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.assignment_turned_in_outlined,
                          size: 28,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              form.title,
                              style: Theme.of(context).textTheme.titleLarge,
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
                )),
          ),
        ));
  }
}
