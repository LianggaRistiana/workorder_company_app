import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/custom_switch_tile.dart';

class PositionFormView extends StatefulWidget {
  final PositionEntity? initialData;
  final bool isLoading;
  final void Function(PositionEntity entity) onSubmit;
  final String submitLabel;

  const PositionFormView({
    super.key,
    this.initialData,
    required this.onSubmit,
    required this.submitLabel,
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
      // Mode create → cek apakah ada input
      return _nameController.text.isNotEmpty ||
          _descriptionController.text.isNotEmpty ||
          _isActive != true;
    }

    // Mode edit → cek perubahan dari initial
    return _nameController.text != initial.name ||
        _descriptionController.text != (initial.description ?? '') ||
        _isActive != initial.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
        child: Column(
          children: [
            CustomInputField(
              label: 'Nama Departemen',
              controller: _nameController,
              prefixIcon: const Icon(Icons.badge_outlined),
              validator: (value) {
                return ValidatorUtils.single(
                    value,
                    fieldName: "Nama Departemen",
                    ValidatorType.required);
              },
            ),
            const SizedBox(height: 16),
            CustomInputField(
              label: 'Deskripsi',
              controller: _descriptionController,
              maxLines: 3,
              prefixIcon: const Icon(Icons.info_outline),
              validator: (value) {
                return ValidatorUtils.single(
                    value, fieldName: "Deskripsi", ValidatorType.required);
              },
            ),
            const SizedBox(height: 20),
            CustomSwitchTile(
              title: 'Status Aktif',
              description: 'Jika nonaktif, Departemen tidak dapat digunakan',
              leadingIcon: Icons.task_alt_outlined,
              value: _isActive,
              onChanged: (val) {
                setState(() {
                  _isActive = val;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(widget.submitLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
