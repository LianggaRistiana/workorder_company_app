// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/has_form.dart';
// import '../../domain/entities/form_entity.dart';
// import 'package:workorder_company_app/shared/widgets/select_buttom_sheet.dart';


// @Deprecated("Use Form Selector Insteds")
// class FormsSelectorWithList<T extends HasForm> extends StatelessWidget {
//   const FormsSelectorWithList({
//     super.key,
//     required this.selectedForms,
//     required this.onAdd,
//     required this.onRemove,
//     required this.onReorder,
//     required this.createEntity,
//     this.itemBuilder,
//   });

//   final List<T> selectedForms;
//   final void Function(T) onAdd;
//   final void Function(T) onRemove;
//   final void Function(int oldIndex, int newIndex) onReorder;
//   final Widget Function(T entity)? itemBuilder;

//   /// Factory function untuk membuat instance baru dari entity generic
//   /// Berdasarkan FormEntity yang dipilih
//   final T Function(FormEntity form, int order) createEntity;

//   Future<void> _openFormSelector(
//     BuildContext context,
//     List<FormEntity> forms,
//     bool isLoading,
//   ) async {
//     if (isLoading) return;

//     final form = await showModalBottomSheet<FormEntity>(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => SelectBottomSheet<FormEntity>(
//         title: 'Pilih Form',
//         items: forms,
//         itemLabel: (form) => form.title,
//         isLoading: isLoading,
//         onSelect: (selected) => Navigator.pop(context, selected),
//       ),
//     );

//     if (form != null && !selectedForms.any((f) => f.form.id == form.id)) {
//       final newEntity = createEntity(form, selectedForms.length + 1);
//       onAdd(newEntity);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FormsBloc, FormsState>(
//       builder: (context, state) {
//         final isLoading = state is FormsLoading;
//         final forms = state is FormsLoaded ? state.forms : <FormEntity>[];

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   "Form",
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 const Spacer(),
//                 OutlinedButton.icon(
//                   icon: const Icon(Icons.add),
//                   label: isLoading
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Text('Tambah Form'),
//                   onPressed: isLoading
//                       ? null
//                       : () => _openFormSelector(context, forms, isLoading),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             if (selectedForms.isEmpty)
//               const Text('Belum ada form yang dipilih')
//             else
//               ReorderableListView(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 proxyDecorator: (child, index, animation) => Material(
//                   color: Colors.transparent,
//                   elevation: 0,
//                   child: child,
//                 ),
//                 onReorder: onReorder,
//                 children: [
//                   for (final formOrder in selectedForms)
//                     itemBuilder != null
//                         ? KeyedSubtree(
//                             key: ValueKey(formOrder.form.id),
//                             child: Builder(
//                               builder: (context) => itemBuilder!(formOrder),
//                             ),
//                           )
//                         : ListTile(
//                             key: ValueKey(formOrder.form.id),
//                             title: Text(formOrder.form.title),
//                             trailing: IconButton(
//                               icon: const Icon(Icons.close),
//                               onPressed: () => onRemove(formOrder),
//                             ),
//                           ),
//                 ],
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
