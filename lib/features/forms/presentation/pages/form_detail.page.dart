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

  // Widget _buildAccessBox(String text,
  //     {Color color = Colors.grey, Color borderColor = Colors.grey}) {
  //   return Container(
  //     width: 100, // fix width
  //     height: 100, // fix height
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //       color: color,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: borderColor),
  //     ),
  //     child: Text(
  //       text,
  //       textAlign: TextAlign.center,
  //       style: const TextStyle(fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }
  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      bloc: _formsBloc,
      builder: (context, state) {
        if (state is FormsError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Service Detail')),
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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),

                      // AccessType + AccessibleBy → horizontal wrap
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Access Type
                          // _buildAccessBox(form.accessType,
                          //     color: Colors.blue.shade50,
                          //     borderColor: Colors.blue.shade100),

                          // Accessible By
                          // ...form.accessibleBy.map<Widget>((role) =>
                          //     _buildAccessBox(role,
                          //         color: Colors.orange.shade50,
                          //         borderColor: Colors.orange.shade100)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Allowed Positions → full width vertical list
                    //   if ((form.allowedPositions ?? []).isNotEmpty) ...[
                    //     const Text(
                    //       'Posisi Diizinkan:',
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //     const SizedBox(height: 8),
                    //     Column(
                    //       children:
                    //           (form.allowedPositions ?? []).map<Widget>((pos) {
                    //         return Container(
                    //           width: double.infinity,
                    //           margin: const EdgeInsets.only(bottom: 8),
                    //           padding: const EdgeInsets.all(12),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(12),
                    //             border:
                    //                 Border.all(color: Colors.grey),
                    //           ),
                    //           child: Text(pos.name),
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ],
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Daftar Field",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final field = form.fields![index];
                    return Container(
                        padding: EdgeInsets.all(8),
                        child: FormFieldCard(field: field));
                  },
                  childCount: form.fields?.length ?? 0,
                ),
              ),
              SliverFillRemaining(),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
