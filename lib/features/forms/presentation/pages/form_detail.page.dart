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
  late FormsBloc _formsBloc;

  @override
  void initState() {
    super.initState();
    _formsBloc = GetIt.I<FormsBloc>()..add(GetFormByIdRequested(widget.formId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      bloc: _formsBloc,
      builder: (context, state) {
        if (state is FormsError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Form Detail')),
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        if (state is FormsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is FormsLoaded) {
          final form = state.selectedForm;

          if (state.isSubLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (form == null && !state.isSubLoading) {
            return Scaffold(
              appBar: AppBar(title: const Text('Form Detail')),
              body: Center(
                child: Text(
                  state.errorMessage ?? 'Form not found',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  expandedTitleScale: 1.5,
                  titlePadding: EdgeInsets.only(bottom: 16),
                  title: Text(form!.title),
                ),
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    left: 8,
                    right: 8
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Deskripsi
                      Text(
                        form.description.isEmpty
                            ? 'Tidak ada deskripsi'
                            : form.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(

                  (context, index) {
                    final field = form.fields![index];
                    return Container(
                        padding: EdgeInsets.only(bottom: 0, left: 8, right: 8),
                        child: FormFieldCard(field: field));
                  },
                  childCount: form.fields?.length ?? 0,
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
