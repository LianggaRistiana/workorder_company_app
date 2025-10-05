import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forms")),
      body: BlocBuilder<FormsBloc, FormsState>(
        bloc: _formBloc,
        builder: (context, state) {
          if (state is FormsInitial || state is FormsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FormsLoaded) {
            final forms = state.forms;
            if (forms.isEmpty) {
              return const Center(child: Text("Belum ada form"));
            }

            return Stack(
              children: [
                ListView.separated(
                  itemCount: forms.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final form = forms[index];
                    return ListTile(
                      title: Text(form.title),
                      subtitle: Text(form.description),
                      trailing: Text(form.accessType),
                      onTap: () {
                        // Navigasi ke halaman detail form
                        context.push(AppRoutes.ownerFormDetail(form.id));
                      },
                    );
                  },
                ),

                // overlay loading kecil saat fetch by id
                if (state.isSubLoading)
                  Container(
                    color: Colors.black38,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          }

          if (state is FormsError) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.ownerNewForm),
        child: const Icon(Icons.add),
      ),
    );
  }
}
