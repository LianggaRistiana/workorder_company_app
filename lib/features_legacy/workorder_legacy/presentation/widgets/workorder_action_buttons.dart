// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/core/theme/app_spacing.dart';
// import 'package:workorder_company_app/features_legacy/workorder_legacy/presentation/bloc/workorder_actions_cubit.dart';
// import 'package:workorder_company_app/features_legacy/workorder_legacy/presentation/bloc/workorder_bloc.dart';
// import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

// class WorkorderActionButtons extends StatelessWidget {
//   final WorkOrderStatus workorderStatus;
//   final VoidCallback? onRefresh;
//   final String workorderId;

//   const WorkorderActionButtons(
//       {super.key,
//       required this.workorderStatus,
//       this.onRefresh,
//       required this.workorderId});

//   @override
//   Widget build(BuildContext context) {
//     switch (workorderStatus) {
//       case WorkOrderStatus.drafted:
//         return BlocConsumer<WorkorderActionsCubit, WorkorderActionsState>(
//             listenWhen: (prev, curr) => prev.status != curr.status,
//             listener: (context, state) {
//               if (state.status == WorkorderStateStatus.error) {
//                 context.showError(state.errorMessage ?? "Terjadi kesalahan");
//               }

//               if (state.status == WorkorderStateStatus.success) {
//                 context.showSuccess("Berhasil menyimpan tugas kerja");

//                 onRefresh?.call();
//               }
//             },
//             builder: (context, state) {
//               final isLoading = state.status == WorkorderStateStatus.loading;
//               return Container(
//                 margin: EdgeInsets.only(
//                   left: AppSpacing.md,
//                   right: AppSpacing.md,
//                   bottom: AppSpacing.lg,
//                 ),
//                 child: Row(
//                   children: [
//                     // TOLAK
//                     TextButton.icon(
//                       label: Text(
//                         "Batalkan",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ),
//                       icon: Icon(
//                         Icons.cancel_outlined,
//                         color: Theme.of(context).colorScheme.error,
//                       ),
//                       onPressed: isLoading ? null : () {},
//                     ),

//                     // SETUJUI
//                     Expanded(
//                       child: FilledButton.icon(
//                         icon: isLoading
//                             ? SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : Icon(Icons.check),
//                         label: Text("Konfirmasi Tugas Kerja"),
//                         onPressed: isLoading
//                             ? null
//                             : () {
//                                 context
//                                     .read<WorkorderActionsCubit>()
//                                     .setToReady(workorderId);
//                               },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             });
//       case WorkOrderStatus.ready:
//         return BlocConsumer<WorkorderActionsCubit, WorkorderActionsState>(
//             listenWhen: (prev, curr) => prev.status != curr.status,
//             listener: (context, state) {
//               if (state.status == WorkorderStateStatus.error) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     behavior: SnackBarBehavior.floating,
//                     content: Text(state.errorMessage ?? "Terjadi kesalahan"),
//                   ),
//                 );
//               }

//               if (state.status == WorkorderStateStatus.success) {
//                 context.showSuccess("Berhasil menyimpan tugas kerja");

//                 onRefresh?.call();
//               }
//             },
//             builder: (context, state) {
//               final isLoading = state.status == WorkorderStateStatus.loading;
//               return Container(
//                 margin: EdgeInsets.only(
//                   left: AppSpacing.md,
//                   right: AppSpacing.md,
//                   bottom: AppSpacing.lg,
//                 ),
//                 child: Row(
//                   children: [
//                     // TOLAK
//                     TextButton.icon(
//                       label: Text(
//                         "Batalkan",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ),
//                       icon: Icon(
//                         Icons.cancel_outlined,
//                         color: Theme.of(context).colorScheme.error,
//                       ),
//                       onPressed: isLoading ? null : () {},
//                     ),

//                     // SETUJUI
//                     Expanded(
//                       child: FilledButton.icon(
//                         icon: isLoading
//                             ? SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : Icon(Icons.play_arrow_rounded),
//                         label: Text("Mulai Tugas Kerja"),
//                         onPressed: isLoading
//                             ? null
//                             : () {
//                                 context
//                                     .read<WorkorderActionsCubit>()
//                                     .setToStart(workorderId);
//                               },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             });
//       case WorkOrderStatus.inProgress:
//         return BlocConsumer<WorkorderActionsCubit, WorkorderActionsState>(
//             listenWhen: (prev, curr) => prev.status != curr.status,
//             listener: (context, state) {
//               if (state.status == WorkorderStateStatus.error) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     behavior: SnackBarBehavior.floating,
//                     content: Text(state.errorMessage ?? "Terjadi kesalahan"),
//                   ),
//                 );
//               }

//               if (state.status == WorkorderStateStatus.success) {
//                 context.showSuccess("Berhasil menyimpan tugas kerja");

//                 onRefresh?.call();
//               }
//             },
//             builder: (context, state) {
//               final isLoading = state.status == WorkorderStateStatus.loading;
//               return Container(
//                 margin: EdgeInsets.only(
//                   left: AppSpacing.md,
//                   right: AppSpacing.md,
//                   bottom: AppSpacing.lg,
//                 ),
//                 child: Row(
//                   children: [
//                     // TOLAK
//                     TextButton.icon(
//                       label: Text(
//                         "Batalkan",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ),
//                       icon: Icon(
//                         Icons.cancel_outlined,
//                         color: Theme.of(context).colorScheme.error,
//                       ),
//                       onPressed: isLoading ? null : () {},
//                     ),
//                     // SETUJUI
//                     Expanded(
//                       child: FilledButton.icon(
//                         icon: isLoading
//                             ? SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : Icon(Icons.check_circle_rounded),
//                         label: Text("Selesaikan Tugas Kerja"),
//                         onPressed: isLoading
//                             ? null
//                             : () {
//                                 // context
//                                 //     .read<WorkorderActionsCubit>()
//                                 //     .setToStart(workorderId);
//                               },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             });
//       default:
//         return SizedBox.shrink();
//     }
//   }
// }
