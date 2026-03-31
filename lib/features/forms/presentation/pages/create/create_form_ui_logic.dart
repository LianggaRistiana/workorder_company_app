// part of 'create_form_page.dart';

// // ignore_for_file: invalid_use_of_protected_member
// extension CreateFormUiLogic on CreateFormPageState {
//   void _addField(FieldType type) {
//     setState(() {
//       _fields.add(EditableField(order: _fields.length + 1, type: type));
//     });
//   }

//   void _openFieldTypePicker() {
//     showAppBottomSheet(
//       context,
//       content: FieldTypeBottomSheet(
//         onSelected: (type) {
//           _addField(type);
//         },
//       ),
//     );
//   }

//   void _removeField(int index) {
//     setState(() {
//       _fields.removeAt(index);
//       for (int i = 0; i < _fields.length; i++) {
//         _fields[i].order = i + 1;
//       }
//     });
//   }

//   void _addOption(int fieldIndex) {
//     setState(() {
//       _fields[fieldIndex].options.add(
//             OptionEntity(
//               key: '${DateTime.now().millisecondsSinceEpoch}',
//               value: '',
//             ),
//           );
//     });
//   }

//   void _onNext(BuildContext context) {
//     final currentIndex = _tabController.index;
//     bool isValid = false;

//     switch (currentIndex) {
//       case 0:
//         isValid = _formKey.currentState?.validate() ?? false;
//         break;
//       case 1:
//     }

//     if (isValid && currentIndex < _tabController.length - 1) {
//       _tabController.animateTo(currentIndex + 1);
//     }
//   }

//   void _onPrevious() {
//     if (_tabController.index > 0) {
//       _tabController.animateTo(_tabController.index - 1);
//     }
//   }

//   void _removeOption(int fieldIndex, int optionIndex) {
//     setState(() => _fields[fieldIndex].options.removeAt(optionIndex));
//   }

//   void _submitForm() {
//     if (_fields.isEmpty) {
//       context.showError("Pertanyaan tidak boleh kosong");
//       return;
//     }

//     if (!(_fieldKey.currentState?.validate() ?? false)) {
//       return;
//     }

//     final form = FormEntity(
//       id: '',
//       title: _titleController.text.trim(),
//       description: _descController.text.trim(),
//       formType: _formType,
//       fields: _fields.map((e) => e.toEntity()).toList(),
//     );

//     // _formCreateCubit.createForm(form);
//   }
// }
