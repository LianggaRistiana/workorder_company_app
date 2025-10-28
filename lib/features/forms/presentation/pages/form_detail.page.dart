import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/features/forms/presentation/widgets/form_field_card.dart';

class FormDetailPage extends StatefulWidget {
  final String formId;

  const FormDetailPage({super.key, required this.formId});

  @override
  State<FormDetailPage> createState() => _FormDetailPageState();
}

class _FormDetailPageState extends State<FormDetailPage> {
  late final FormsBloc _formsBloc;

  @override
  void initState() {
    super.initState();
    _formsBloc = GetIt.I<FormsBloc>()..add(GetFormByIdRequested(widget.formId));
  }

  @override
  void dispose() {
    _formsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      bloc: _formsBloc,
      builder: (context, state) {
        String appBarTitle = "Form Detail";
        if (state is FormsLoaded && state.selectedForm != null) {
          appBarTitle = state.selectedForm!.title;
        }

        return Scaffold(
          body: _buildBody(context, state, appBarTitle),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, FormsState state, String title) {
    if (state is FormsLoading || state is FormsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FormsError) {
      return _buildErrorState(state.message);
    }

    if (state is FormsLoaded) {
      if (state.isSubLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final form = state.selectedForm;
      if (form == null) {
        return _buildErrorState(state.errorMessage ?? "Form not found");
      }

      return CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              expandedTitleScale: 1.5,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: Text(title),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    form.description.isEmpty
                        ? 'Tidak ada deskripsi'
                        : form.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    form.formType.displayName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  const Divider(thickness: 0.6),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final field = form.fields![index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: FormFieldCard(field: field),
                );
              },
              childCount: form.fields?.length ?? 0,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
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
