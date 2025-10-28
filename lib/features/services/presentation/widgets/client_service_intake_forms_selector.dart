// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
// import 'package:workorder_company_app/features/forms/presentation/widgets/forms_selector.dart';
// import 'package:workorder_company_app/features/services/presentation/bloc/add_service_cubit.dart';
// import 'package:workorder_company_app/features/services/presentation/bloc/service_config_state.dart';
// import 'package:workorder_company_app/shared/utils/reorder_helper_util.dart';
// import 'package:workorder_company_app/shared/widgets/custom_card.dart';
// import 'package:workorder_company_app/shared/widgets/custom_list.dart';

// class ClientServiceIntakeFormsSelector extends StatelessWidget {
//   const ClientServiceIntakeFormsSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<AddServiceCubit, ServiceConfigState,
//         List<OrderedFormEntity>>(
//       selector: (state) => state.serviceConfig.selectedIntakeForms,
//       builder: (context, selectedForms) {
//         return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
//             Text("Form Publik", style: Theme.of(context).textTheme.titleMedium),
//             const Spacer(),
//             FormsSelector(
//                 selectedForms: selectedForms.map((f) => f.form).toList(),
//                 onAdd: (form) {
//                   context.read<AddServiceCubit>().addIntakeForm(form);
//                 })
//           ]),
//           const SizedBox(height: 12),
//           CustomList(
//               isReorderable: true,
//               onReorder: (oldIndex, newIndex) {
//                 final updated = List<OrderedFormEntity>.from(selectedForms);
//                 updated.reorderWithCallback(oldIndex, newIndex, (item, i) {
//                   updated[i] = item.copyWith(order: i + 1);
//                 });
//                 context
//                     .read<AddServiceCubit>()
//                     .updateSelectedIntakeForms(updated);
//               },
//               items: selectedForms,
//               itemBuilder: (item, _) => _buildFormItem(
//                 item.form, 
//                 (form) => context.read<AddServiceCubit>().removeIntakeForm(form)))
//         ]);
//       },
//     );
//   }

//   Widget _buildFormItem(FormEntity form, void Function(FormEntity) onRemove) {
//     return CustomCard(
//       margin: const EdgeInsets.all(0),
//       padding: const EdgeInsets.all(0),
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Text(
//                 form.title,
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete_outline),
//               onPressed: () => onRemove(form),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
