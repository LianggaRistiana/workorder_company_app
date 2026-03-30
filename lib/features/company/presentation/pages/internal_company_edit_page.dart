import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_update_company_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_update_company_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_switch_tile.dart';

/// ===============================
/// PAGE (Stateless)
/// ===============================
class InternalCompanyEditPage extends StatelessWidget {
  final CompanyEntity company;

  const InternalCompanyEditPage({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InternalUpdateCompanyCubit>(),
      child: InternalCompanyEditView(company: company),
    );
  }
}

/// ===============================
/// VIEW (Stateful)
/// ===============================
class InternalCompanyEditView extends StatefulWidget {
  final CompanyEntity company;

  const InternalCompanyEditView({
    super.key,
    required this.company,
  });

  @override
  State<InternalCompanyEditView> createState() =>
      _InternalCompanyEditViewState();
}

class _InternalCompanyEditViewState extends State<InternalCompanyEditView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _descriptionController;

  late bool _isActive;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.company.name);
    _addressController = TextEditingController(text: widget.company.address);
    _descriptionController =
        TextEditingController(text: widget.company.description);

    _isActive = widget.company.isActive;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final updatedCompany = widget.company.copyWith(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      description: _descriptionController.text.trim(),
      isActive: _isActive,
    );

    context.read<InternalUpdateCompanyCubit>().submit(updatedCompany);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternalUpdateCompanyCubit, InternalUpdateCompanyState>(
      listener: (context, state) {
        if (state.success) {
          Navigator.pop(context, true);
        }

        if (state.error != null) {
          context.showError(state.error ?? "Terjadi kesalahan");
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Perusahaan"),
          ),
          body: SafeArea(
            child: AbsorbPointer(
              absorbing: state.isSaving,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomInputField(
                              label: "Nama Perusahaan",
                              controller: _nameController,
                              prefixIcon: const Icon(AppIcon.company),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Nama perusahaan wajib diisi";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomInputField(
                              label: "Alamat",
                              controller: _addressController,
                              prefixIcon:
                                  const Icon(Icons.location_on_outlined),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 20),
                            CustomInputField(
                              label: "Deskripsi",
                              controller: _descriptionController,
                              prefixIcon: const Icon(AppIcon.desc),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 24),
                            CustomSwitchTile(
                              title: "Perusahaan Aktif",
                              description:
                                  "Nonaktifkan jika perusahaan tidak beroperasi",
                              leadingIcon: AppIcon.activeState,
                              value: _isActive,
                              onChanged: (value) {
                                setState(() {
                                  _isActive = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Sticky Button
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: ButtonWithLoadingState(
                      onPressed: _submit,
                      isLoading: state.isSaving,
                      label: "Simpan",
                      icon: AppIcon.submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
