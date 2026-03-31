// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/core/di/injection.dart';
// import 'package:workorder_company_app/core/theme/app_spacing.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/option_entity.dart';
// import 'package:workorder_company_app/features/forms/presentation/bloc/create/form_create_cubit.dart';
// import 'package:workorder_company_app/features/forms/presentation/bloc/create/form_create_state.dart';
// import 'package:workorder_company_app/features/helps/presentation/widgets/form_type_tips.dart';
// import 'package:workorder_company_app/features/forms/presentation/widgets/field_type_buttom_sheet.dart';
// import 'package:workorder_company_app/features/forms/presentation/widgets/field_type_icon.dart';
// import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
// import 'package:workorder_company_app/shared/utils/reorder_helper_util.dart';
// import 'package:workorder_company_app/shared/widgets/custom_card.dart';
// import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
// import 'package:workorder_company_app/shared/widgets/custom_list.dart';
// import 'package:workorder_company_app/shared/widgets/custom_step_indicator.dart';
// import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
// import 'package:workorder_company_app/shared/widgets/enum_selector.dart';
// import 'package:workorder_company_app/features/helps/presentation/widgets/help_button.dart';
// import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';
// import 'package:workorder_company_app/shared/widgets/information_block.dart';
// import 'package:workorder_company_app/shared/widgets/reorderable_custom_list.dart';
// import 'package:workorder_company_app/shared/widgets/step_navigation_bar.dart';

// part 'create_form_widget_builder.dart';
// part 'create_form_ui_logic.dart';

// class CreateFormPage extends StatefulWidget {
//   const CreateFormPage({super.key});

//   @override
//   State<CreateFormPage> createState() => CreateFormPageState();
// }

// class EditableField {
//   String label;
//   FieldType type;
//   bool required;
//   int? min;
//   int? max;
//   String? placeholder;
//   List<OptionEntity> options;
//   int order;

//   EditableField({
//     this.label = '',
//     required this.type,
//     this.required = false,
//     this.placeholder,
//     this.min,
//     this.max,
//     this.order = 1,
//     List<OptionEntity>? options,
//   }) : options = options ?? [];

//   FieldEntity toEntity() => FieldEntity(
//         label: label,
//         type: type,
//         required: required,
//         placeholder: placeholder,
//         min: min,
//         max: max,
//         options: options,
//         order: order,
//       );
// }

// class CreateFormPageState extends State<CreateFormPage>
//     with TickerProviderStateMixin {
//   late final FormCreateCubit _formCreateCubit;
//   late final TabController _tabController;

//   final _formKey = GlobalKey<FormState>();
//   final _fieldKey = GlobalKey<FormState>();

//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();
//   final List<EditableField> _fields = [];

//   FormType _formType = FormType.workOrder;

//   @override
//   void initState() {
//     super.initState();
//     _formCreateCubit = sl<FormCreateCubit>();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _formCreateCubit,
//       child: BlocListener<FormCreateCubit, FormCreateState>(
//         listener: (context, state) {
//           if (state.status == FormCreateStatus.success) {
//             context.showSuccess("Formulir berhasil dibuat");

//             Navigator.pop(context);
//           } else if (state.status == FormCreateStatus.error) {
//             context.showError(state.errorMessage ?? 'Terjadi kesalahan');
//           }
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Buat Formulir'),
//             bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(72),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: CustomStepIndicator(
//                   currentStep: _tabController.index,
//                   steps: const ['Pengaturan Formulir', 'Pertanyaan'],
//                 ),
//               ),
//             ),
//           ),
//           bottomNavigationBar: StepNavigationBar(
//             currentStep: _tabController.index,
//             totalSteps: 2,
//             onPrevious: _onPrevious,
//             onNext: () => _onNext(context),
//             finalAction: BlocBuilder<FormCreateCubit, FormCreateState>(
//               builder: (context, state) {
//                 final isLoading = state.status == FormCreateStatus.loading;
//                 return ElevatedButton(
//                   onPressed: isLoading ? null : _submitForm,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.primary,
//                     foregroundColor: Theme.of(context).colorScheme.onPrimary,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                   ),
//                   child: isLoading
//                       ? const SizedBox(
//                           height: 18,
//                           width: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Text('Simpan Form'),
//                 );
//               },
//             ),
//           ),
//           body: TabBarView(
//             controller: _tabController,
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               // Tab 1: Pengaturan Form
//               SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(children: [_buildFormSetting()]),
//                 ),
//               ),

//               // Tab 2: Pertanyaan
//               SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Form(
//                   key: _fieldKey,
//                   child: Column(children: [_buildFields()]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
