import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/shared/widgets/select_buttom_sheet.dart';

class FormsSelector extends StatelessWidget {
  const FormsSelector({
    super.key,
    required this.selectedForms,
    required this.availableForms,
    required this.onAdd,
    required this.buttonBuilder,
    this.isLoading = false,
  });

  final List<FormEntity> selectedForms;
  final List<FormEntity> availableForms;
  final void Function(FormEntity) onAdd;
  final bool isLoading;

  /// builder untuk tombol
  final Widget Function(
    BuildContext context,
    VoidCallback onPressed,
    bool isLoading,
  ) buttonBuilder;

  Future<void> _openFormSelector(BuildContext context) async {
    if (isLoading) return;

    final form = await showModalBottomSheet<FormEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SelectBottomSheet<FormEntity>(
        title: 'Pilih Form',
        items: availableForms,
        itemLabel: (f) => f.title,
        isLoading: isLoading,
        onSelect: (selected) => Navigator.pop(context, selected),
      ),
    );

    if (form != null &&
        !selectedForms.any((f) => f.id == form.id)) {
      onAdd(form);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buttonBuilder(
      context,
      () => _openFormSelector(context),
      isLoading,
    );
  }
}