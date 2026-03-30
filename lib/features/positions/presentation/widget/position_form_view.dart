import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/positions/domain/properties/position_property.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_switch_tile.dart';

class PositionFormView extends StatefulWidget {
  final ValidationFailure? validation;
  final PositionEntity? initialData;
  final bool isLoading;
  final void Function(PositionEntity entity) onSubmit;
  final String submitLabel;

  const PositionFormView({
    super.key,
    this.initialData,
    required this.onSubmit,
    required this.submitLabel,
    this.validation,
    this.isLoading = false,
  });

  @override
  State<PositionFormView> createState() => _PositionFormViewState();
}

class _PositionFormViewState extends State<PositionFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialData?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialData?.description ?? '');
    _isActive = widget.initialData?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final entity = PositionEntity(
      id: widget.initialData?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      isActive: _isActive,
    );

    widget.onSubmit(entity);
  }

  bool get _isDirty {
    final initial = widget.initialData;

    if (initial == null) {
      return _nameController.text.isNotEmpty ||
          _descriptionController.text.isNotEmpty ||
          _isActive != true;
    }

    return _nameController.text != initial.name ||
        _descriptionController.text != (initial.description ?? '') ||
        _isActive != initial.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.initialData == null ? "Tambah Departemen" : "Edit Departemen",
        ),
      ),

      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          if (_isDirty) {
            final shouldLeave = await showConfirmDialog(
              context: context,
              title: "Konfirmasi",
              message: "Apakah Anda yakin ingin meninggalkan halaman ini?",
              type: ConfirmDialogType.warning,
            );

            if (!context.mounted) return;
            if (shouldLeave == true) {
              context.pop();
            }
          } else {
            if (!mounted) return;
            context.pop();
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomInputField(
                  label: 'Nama Departemen',
                  controller: _nameController,
                  enabled: !widget.isLoading,
                  prefixIcon: const Icon(AppIcon.department),
                  errorText: widget.validation?.errorOf(PositionProperty.name),
                  validator: (value) {
                    return ValidatorUtils.single(
                      value,
                      fieldName: "Nama Departemen",
                      ValidatorType.required,
                    );
                  },
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  label: 'Deskripsi',
                  enabled: !widget.isLoading,
                  controller: _descriptionController,
                  errorText:
                      widget.validation?.errorOf(PositionProperty.description),
                  maxLines: 3,
                  prefixIcon: const Icon(AppIcon.desc),
                ),
                const SizedBox(height: 20),
                CustomSwitchTile(
                  title: 'Status Aktif',
                  description:
                      'Jika nonaktif, Departemen tidak dapat digunakan',
                  leadingIcon: AppIcon.activeState,
                  value: _isActive,
                  onChanged: (val) {
                    setState(() {
                      _isActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      /// 🔹 Bottom Button (Auto-handle keyboard)
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ButtonWithLoadingState(
          onPressed: _handleSubmit,
          isLoading: widget.isLoading,
          icon: AppIcon.submit,
          label: widget.submitLabel,
        ),
      ),
    );
  }
}
