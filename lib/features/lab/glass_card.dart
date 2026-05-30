// import 'dart:ui';

// import 'package:flutter/material.dart';

// class GlassCard extends StatelessWidget {
//   final Widget child;

//   const GlassCard({
//     super.key,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return AspectRatio(
//       aspectRatio: 1,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(32),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 32,
//             sigmaY: 32,
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               borderRadius:
//                   BorderRadius.circular(32),

//               // wajib ada transparency agar blur terlihat
//               color: theme.colorScheme.surface
//                   .withOpacity(0.12),

//               border: Border.all(
//                 color: theme.colorScheme.outline
//                     .withOpacity(0.08),
//                 width: 1,
//               ),
//             ),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }