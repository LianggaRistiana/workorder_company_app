import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/forms/presentation/bloc/forms_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';

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
        title: const Text("Forms"),
        centerTitle: true,
      ),
      body: BlocBuilder<FormsBloc, FormsState>(
        bloc: _formBloc,
        builder: (context, state) {
          if (state is FormsInitial || state is FormsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FormsLoaded) {
            final forms = state.forms;
            if (forms.isEmpty) {
              return const Center(
                child: Text(
                  "Belum ada form",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    itemCount: forms.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final form = forms[index];
                      return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: CustomCard(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                context
                                    .push(AppRoutes.ownerFormDetail(form.id));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            form.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: form.accessType == "internal"
                                                ? Colors.blue.shade100
                                                : Colors.green.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            form.accessType.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  form.accessType == "internal"
                                                      ? Colors.blue.shade800
                                                      : Colors.green.shade800,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      form.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                ),

                // overlay loading kecil saat fetch by id
                if (state.isSubLoading)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }

          if (state is FormsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.ownerNewForm),
        label: const Text("Tambah Form"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
