// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/core/di/injection.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
// import 'package:workorder_company_app/features/forms/presentation/bloc/list/forms_list_bloc.dart';
// import 'package:workorder_company_app/features/forms/presentation/widgets/old_forms_selector.dart';
// import 'package:workorder_company_app/features/positions/presentation/bloc/positions_bloc.dart';
// import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/service_form_entity.dart';
// import 'package:workorder_company_app/features/services/presentation/widgets/required_positions_setting.dart';
// import 'package:workorder_company_app/features/services/presentation/widgets/service_form_editor_card.dart';
// import 'package:workorder_company_app/features/services/presentation/widgets/service_setting_card.dart';
// import 'package:workorder_company_app/shared/utils/remove_item_list_util.dart';
// import 'package:workorder_company_app/shared/utils/reorder_helper_util.dart';
// import 'package:workorder_company_app/shared/widgets/custom_step_indicator.dart';
// import 'package:workorder_company_app/shared/widgets/step_navigation_bar.dart';
// import '../../../domain/entities/required_staff_entity.dart';
// import '../../bloc/services_bloc.dart';

// part 'create_new_service_logic.dart';
// part 'service_setting_tab.dart';
// part 'workorder_tab.dart';
// part 'report_tab.dart';

// class CreateServicePage extends StatefulWidget {
//   const CreateServicePage({super.key});

//   @override
//   State<CreateServicePage> createState() => CreateServicePageState();
// }

// class CreateServicePageState extends State<CreateServicePage>
//     with TickerProviderStateMixin {
//   final _serviceKey = GlobalKey<FormState>();

//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();

//   late final TabController _tabController;
//   late final ServicesBloc _servicesBloc;
//   late final FormsListBloc _formsBloc;
//   late final PositionsBloc _positionsBloc;

//   List<RequiredStaffEntity> requiredStaff = [];
//   List<OrderedFormEntity> selectedIntakeForms = [];
//   List<ServiceFormEntity> selectedWorkOrderForms = [];
//   List<ServiceFormEntity> selectedReportForms = [];
//   ServiceAccessType accessType = ServiceAccessType.internal;
//   bool isActive = true;

//   @override
//   void initState() {
//     super.initState();
//     _servicesBloc = sl<ServicesBloc>();
//     _formsBloc = sl<FormsListBloc>()..add(GetFormsListRequested());
//     _positionsBloc = sl<PositionsBloc>()..add(GetPositionsRequested());
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.addListener(() {
//       if (_tabController.indexIsChanging) {
//         setState(() {});
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descController.dispose();
//     _servicesBloc.close();
//     _formsBloc.close();
//     _positionsBloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: _servicesBloc),
//         BlocProvider.value(value: _formsBloc),
//         BlocProvider.value(value: _positionsBloc),
//       ],
//       child: BlocListener<ServicesBloc, ServicesState>(
//         listener: (context, state) {
//           if (state is ServicesLoaded && !state.isSubLoading) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Service berhasil dibuat!')),
//             );
//           } else if (state is ServicesError) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         child: DefaultTabController(
//           length: 3,
//           child: Scaffold(
//             appBar: AppBar(
//               title: const Text('Buat Layanan'),
//               bottom: PreferredSize(
//                 preferredSize: const Size.fromHeight(72),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: CustomStepIndicator(
//                     currentStep: _tabController.index,
//                     steps: const [
//                       'Pengaturan Layanan',
//                       'Formulir Tugas Kerja',
//                       'Formulir Laporan'
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             bottomNavigationBar: StepNavigationBar(
//                 currentStep: _tabController.index,
//                 totalSteps: 3,
//                 onPrevious: _onPrevious,
//                 onNext: () => _onNext(context),
//                 finalAction: BlocSelector<ServicesBloc, ServicesState, bool>(
//                   selector: (state) =>
//                       state is ServicesLoaded ? state.isSubLoading : false,
//                   builder: (context, isLoading) {
//                     return ElevatedButton(
//                       onPressed: isLoading ? null : _onSubmit,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 12),
//                       ),
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 18,
//                               width: 18,
//                               child: CircularProgressIndicator(
//                                   strokeWidth: 2, color: Colors.white),
//                             )
//                           : Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: const [
//                                 Icon(Icons.upload),
//                                 SizedBox(width: 8),
//                                 Text('Simpan Layanan'),
//                               ],
//                             ),
//                     );
//                   },
//                 )),
//             body: BlocBuilder<ServicesBloc, ServicesState>(
//               buildWhen: (previous, current) {
//                 if (previous is ServicesLoaded && current is ServicesLoaded) {
//                   return previous.isSubLoading != current.isSubLoading;
//                 }
//                 return previous.runtimeType != current.runtimeType;
//               },
//               builder: (context, state) {
//                 return TabBarView(
//                   controller: _tabController,
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     // Tab 1
//                     _buildServiceSettingTab(),
//                     // Tab 2 (Form WO)
//                     _buildWorkOrdertab(),
//                     // Tab 3 (Form Laporan)
//                     _buildReportTab()
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
