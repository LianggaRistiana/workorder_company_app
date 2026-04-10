// import 'package:flutter/material.dart';
// import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/core/theme/app_spacing.dart';
// import 'package:workorder_company_app/features_legacy/client_service_request_legacy/presentation/widgets/csr_status_chip.dart';

// class CsrStatusStep extends StatelessWidget {
//   final ClientServiceRequestStatus status;
//   const CsrStatusStep({super.key, required this.status});

//   @override
//   Widget build(BuildContext context) {
//     int currentStep = 1;
//     Color activeColor = Theme.of(context).colorScheme.primary;
//     Color inActiveColor = Theme.of(context).disabledColor;

//     switch (status) {
//       case ClientServiceRequestStatus.received:
//         currentStep = 1;
//       case ClientServiceRequestStatus.approved:
//         currentStep = 2;
//       case ClientServiceRequestStatus.workOrderCreated:
//         currentStep = 3;
//       case ClientServiceRequestStatus.completed:
//         currentStep = 4;
//       default:
//         currentStep = 0;
//     }

//     Widget stepBridgeBuilder(int step) {
//       return Expanded(
//           child: Container(
//               color: currentStep <= step ? inActiveColor : activeColor,
//               height: 2));
//     }

//     Widget stepBuilder(int step) {
//       final active = step == currentStep;
//       return active
//           ? CsrStatusChip(status: status, showIcon: true)
//           : CircleAvatar(
//               radius: 12,
//               backgroundColor: currentStep < step ? inActiveColor : activeColor,
//               child: Text(
//                 '$step',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//     }

//     return currentStep == 0
//         ? CsrStatusChip(status: status, showIcon: true)
//         : Container(
//             padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
//             child: Row(
//               children: [
//                 stepBuilder(1),
//                 stepBridgeBuilder(1),
//                 stepBuilder(2),
//                 stepBridgeBuilder(2),
//                 stepBuilder(3),
//                 stepBridgeBuilder(3),
//                 stepBuilder(4)
//               ],
//             ),
//           );
//   }
// }
