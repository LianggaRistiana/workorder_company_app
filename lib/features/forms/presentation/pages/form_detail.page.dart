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
    _formsBloc = GetIt.I<FormsBloc>()..add(GetFormByIdRequested(widget.formId));
  }

  IconData _getAccessIcon(String type) {
    switch (type.toLowerCase()) {
      case 'public':
        return Icons.public_rounded;
      case 'member-only':
        return Icons.group_rounded;
      case 'internal':
        return Icons.apartment_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getAccessColor(String type) {
    switch (type.toLowerCase()) {
      case 'public':
        return Colors.teal;
      case 'member-only':
        return Colors.orangeAccent;
      case 'internal':
        return Colors.deepPurpleAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Form")),
      body: BlocBuilder<FormsBloc, FormsState>(
        bloc: _formsBloc,
        builder: (context, state) {
          if (state is FormsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FormsLoaded) {
            final form = state.selectedForm;

            if (form == null && !state.isSubLoading) {
              return const Center(child: Text("Data form tidak ditemukan"));
            }

            return Stack(
              children: [
                if (form != null)
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🧾 FORM INFO CARD
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  form.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  form.description.isEmpty
                                      ? 'Tidak ada deskripsi'
                                      : form.description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 16),
                                Divider(),
                                const SizedBox(height: 8),

                                // Access type with icon
                                Row(
                                  children: [
                                    Icon(
                                      _getAccessIcon(form.accessType),
                                      color: _getAccessColor(form.accessType),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tipe Akses: ${form.accessType}',
                                      style: TextStyle(
                                        color: _getAccessColor(form.accessType),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.people_alt_outlined,
                                        color: Colors.blueGrey),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Dapat diakses oleh: ${(form.accessibleBy ?? []).join(", ").isEmpty ? "Tidak ditentukan" : (form.accessibleBy ?? []).join(", ")}',
                                      ),
                                    ),
                                  ],
                                ),
                                if ((form.allowedPositions ?? []).isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.badge_outlined,
                                            color: Colors.indigo),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Posisi Diizinkan: ${(form.allowedPositions ?? []).map((p) => p.name).join(", ")}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🧩 FIELD LIST
                        Text(
                          'Daftar Field',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        if ((form.fields ?? []).isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text('Tidak ada field dalam form ini.'),
                          )
                        else
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: form.fields!.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final field = form.fields![index];

                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              field.label,
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
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              field.type,
                                              style: const TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            field.required
                                                ? Icons.warning_amber_rounded
                                                : Icons.info_outline_rounded,
                                            color: field.required
                                                ? Colors.lightBlue
                                                : Colors.grey,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            field.required
                                                ? "Wajib diisi"
                                                : "Opsional",
                                            style: TextStyle(
                                              color: field.required
                                                  ? Colors.lightBlue
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (field.min != null ||
                                          field.max != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "Range nilai: ${field.min ?? '-'} - ${field.max ?? '-'}",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      // if ((field.options ?? []).isNotEmpty) ...[
                                      //   const Divider(height: 20),
                                      //   const Text(
                                      //     'Opsi:',
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.bold),
                                      //   ),
                                      //   const SizedBox(height: 4),
                                      //   Column(
                                      //     children:
                                      //         field.options!.map((option) {
                                      //       return ListTile(
                                      //         dense: true,
                                      //         leading: const Icon(
                                      //           Icons.circle,
                                      //           size: 8,
                                      //           color: Colors.grey,
                                      //         ),
                                      //         title: Text(option.value),
                                      //       );
                                      //     }).toList(),
                                      //   ),
                                      // ],
                                      if ((field.options ?? []).isNotEmpty) ...[
                                        const Divider(height: 20),
                                        const Text(
                                          'Opsi:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),

                                        // Gunakan ListView.separated untuk opsi vertikal dengan divider
                                        ListView.separated(
                                          shrinkWrap:
                                              true, // agar tidak mengambil seluruh tinggi
                                          physics:
                                              const NeverScrollableScrollPhysics(), // scroll tetap di SingleChildScrollView utama
                                          itemCount: field.options!.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 4),
                                          itemBuilder: (context, index) {
                                            final option =
                                                field.options![index];
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.grey.shade50,
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.circle,
                                                      size: 8,
                                                      color: Colors.grey),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                      child:
                                                          Text(option.value)),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),

                // ⏳ Overlay loading kecil
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
