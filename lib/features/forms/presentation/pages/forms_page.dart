import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';

class FormsPage extends StatefulWidget {
  const FormsPage({super.key});

  @override
  State<FormsPage> createState() => _FormsPageState();
}

class _FormsPageState extends State<FormsPage> {
  late FormsBloc _formBloc;

  @override
  void initState() {
    super.initState();
    _formBloc = GetIt.I<FormsBloc>()..add(GetFormsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forms"),
      ),
      body: BlocBuilder<FormsBloc, FormsState>(
        bloc: _formBloc,
        builder: (context, state) {
          if (state is FormsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FormsLoaded) {
            final List<FormEntity> forms = state.forms;
            if (forms.isEmpty) {
              return const Center(child: Text("Belum ada form"));
            }
            return ListView.separated(
              itemCount: forms.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final form = forms[index];
                return ListTile(
                  title: Text(form.title),
                  subtitle: Text(form.description),
                  trailing: Text(form.accessType),
                  onTap: () {
                    // TODO: navigate ke detail form kalau perlu
                  },
                );
              },
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
