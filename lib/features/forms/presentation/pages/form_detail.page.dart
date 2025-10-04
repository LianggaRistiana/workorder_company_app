import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';

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
    _formsBloc = GetIt.I<FormsBloc>()
      ..add(GetFormByIdRequested(widget.formId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Detail")),
      body: BlocBuilder<FormsBloc, FormsState>(
        bloc: _formsBloc,
        builder: (context, state) {
          if (state is FormsLoading) {
            // loading penuh (misal belum ada data sama sekali)
            return const Center(child: CircularProgressIndicator());
          } else if (state is FormsLoaded) {
            final form = state.selectedForm;

            if (form == null && !state.isSubLoading) {
              return const Center(child: Text("Data form tidak ditemukan"));
            }

            return Stack(
              children: [
                if (form != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Text(
                          form.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(form.description),
                        const SizedBox(height: 24),
                        Text('Access Type: ${form.accessType}'),

                        // fields jika ada
                        if ((form.fields ?? []).isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'Fields:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...form.fields!.map(
                            (f) => ListTile(
                              title: Text(f.label),
                              subtitle: Text('Type: ${f.type}'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                // overlay sub-loading spinner
                if (state.isSubLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          } else if (state is FormsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
