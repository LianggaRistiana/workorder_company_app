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


// class FormsSelector extends StatelessWidget {
//   const FormsSelector({
//     super.key,
//     required this.selectedForms,
//     required this.onAdd,
//     this.selectableForms,
//     this.useBloc = true,
//   });

//   final List<FormEntity> selectedForms;
//   final void Function(FormEntity) onAdd;
//   final List<FormEntity>? selectableForms;
//   final bool useBloc;

//   Future<void> _openFormSelectorDialog(
//       BuildContext context, List<FormEntity> forms, bool isLoading) async {
//     if (isLoading) return;

//     final form = await showModalBottomSheet<FormEntity>(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => SelectBottomSheet<FormEntity>(
//         title: 'Pilih Form',
//         items: forms,
//         itemLabel: (form) => form.title,
//         onSelect: (selected) => Navigator.pop(context, selected),
//       ),
//     );

//     if (form != null && !selectedForms.any((f) => f.id == form.id)) {
//       onAdd(form);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (useBloc) {
//       return BlocBuilder<FormsBloc, FormsState>(
//         builder: (context, state) {
//           final isLoading = state is FormsLoading;
//           final availablePositions =
//               state is FormsLoaded ? state.forms : <FormEntity>[];
//           return _buildButton(context, availablePositions, isLoading);
//         },
//       );
//     } else {
//       return _buildButton(context, selectableForms ?? [], false);
//     }
//   }

//   Widget _buildButton(
//       BuildContext context, List<FormEntity> selectableForms, bool isLoading) {
//     return OutlinedButton.icon(
//       icon: const Icon(Icons.add),
//       label: isLoading
//           ? const SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(strokeWidth: 2),
//             )
//           : const Text('Tambah Form'),
//       onPressed: isLoading
//           ? null
//           : () => _openFormSelectorDialog(context, selectableForms, isLoading),
//     );
//   }
// }
