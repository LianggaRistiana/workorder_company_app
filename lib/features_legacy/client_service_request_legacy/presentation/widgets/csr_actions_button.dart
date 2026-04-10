// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/core/theme/app_spacing.dart';
// import 'package:workorder_company_app/features_legacy/client_service_request_legacy/presentation/bloc/internal_client_service_request/internal_csr_actions_cubit.dart';
// import 'package:workorder_company_app/features_legacy/client_service_request_legacy/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
// import 'package:workorder_company_app/routes/app_routes.dart';
// import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// class CsrActionsButton extends StatelessWidget {
//   final ClientServiceRequestStatus csrStatus;
//   final VoidCallback? onRefresh;
//   final String csrId;

//   const CsrActionsButton({
//     super.key,
//     required this.csrStatus,
//     required this.csrId,
//     this.onRefresh,
//   });

//   @override
//   Widget build(BuildContext context) {
//     switch (csrStatus) {
//       case ClientServiceRequestStatus.received:
//         return BlocListener<InternalCsrActionsCubit, InternalCsrActionsState>(
//           listenWhen: (prev, curr) => prev.status != curr.status,
//           listener: (context, state) {
//             if (state.status == CsrStateStatus.error) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   behavior: SnackBarBehavior.floating,
//                   content: Text(state.errorMessage ?? "Terjadi kesalahan"),
//                 ),
//               );
//             }

//             if (state.status == CsrStateStatus.rejected) {
//               onRefresh?.call();
//             }

//             if (state.status == CsrStateStatus.loaded &&
//                 state.workorderId != null &&
//                 state.workorderId!.isNotEmpty) {
//               context.push(
//                 AppRoutes.workorders.fillId(state.workorderId!),
//               );
//             }
//           },
//           child: BlocBuilder<InternalCsrActionsCubit, InternalCsrActionsState>(
//             builder: (context, state) {
//               final isLoading = state.status == CsrStateStatus.loading;

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
//                         "Tolak",
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.error,
//                         ),
//                       ),
//                       icon: Icon(
//                         Icons.cancel_outlined,
//                         color: Theme.of(context).colorScheme.error,
//                       ),
//                       onPressed: isLoading
//                           ? null
//                           : () {
//                               context
//                                   .read<InternalCsrActionsCubit>()
//                                   .rejectCsr(csrId);
//                             },
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
//                         label: Text("Setujui Pengajuan"),
//                         onPressed: isLoading
//                             ? null
//                             : () {
//                                 context
//                                     .read<InternalCsrActionsCubit>()
//                                     .approveCsr(csrId);
//                               },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );

//       default:
//         return SizedBox.shrink();
//     }
//   }
// }
